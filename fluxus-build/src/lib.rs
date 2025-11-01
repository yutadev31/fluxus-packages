pub mod utils;

use std::{
    collections::HashMap,
    fs::{self, create_dir_all},
};

use serde::{Deserialize, Serialize};

use crate::utils::{run_command, run_command_with_envs};

const SOURCE_DIR: &str = ".sources";
const DIST_DIR: &str = ".dist";

#[derive(Debug, Clone, Default, Deserialize)]
struct Source {
    url: String,
}

#[derive(Debug, Clone, Default, Deserialize)]
struct Prepare {
    source: Source,
    #[serde(default)]
    additionals: Vec<Source>,
    #[serde(default)]
    patch_strip: usize,
    #[serde(default)]
    patches: Vec<Source>,
    #[serde(default)]
    envs: HashMap<String, String>,
    #[serde(default)]
    steps: Vec<String>,
}

#[derive(Debug, Clone, Default, Deserialize)]
struct Build {
    #[serde(default)]
    depends: Vec<String>,
    #[serde(default)]
    envs: HashMap<String, String>,
    #[serde(default)]
    steps: Vec<String>,
}

#[derive(Debug, Clone, Default, Deserialize)]
struct Test {
    #[serde(default)]
    depends: Vec<String>,
    #[serde(default)]
    envs: HashMap<String, String>,
    #[serde(default)]
    steps: Vec<String>,
}

#[derive(Debug, Clone, Deserialize)]
struct Package {
    meta: Metadata,
    #[serde(default)]
    depends: Vec<String>,
    #[serde(default)]
    provides: Vec<String>,
    #[serde(default)]
    envs: HashMap<String, String>,
    #[serde(default)]
    steps: Vec<String>,
}

#[derive(Debug, Clone, Deserialize)]
struct PackageFile {
    #[serde(default)]
    prepare: Prepare,
    #[serde(default)]
    build: Build,
    #[serde(default)]
    test: Test,
    packages: Vec<Package>,
}

impl PackageFile {
    fn open(path: &str) -> anyhow::Result<Self> {
        let content = std::fs::read_to_string(path)?;
        let metadata: PackageFile = serde_yaml::from_str(&content)?;
        Ok(metadata)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Metadata {
    name: String,
    version: String,
    release: String,
    description: String,
}

fn get_pkgfile(package: &str) -> anyhow::Result<PackageFile> {
    let meta_path = format!("pkgs/{}/pkg.yaml", package);
    PackageFile::open(&meta_path)
}

fn get_dirs(package: &str) -> anyhow::Result<(String, String)> {
    let work_dir = format!("/tmp/work-{}", package);
    let pkg_dir = format!("/tmp/pkg-{}", package);
    Ok((work_dir, pkg_dir))
}

fn cleanup(work_dir: &str, pkg_dir: &str) -> anyhow::Result<()> {
    if fs::exists(work_dir)? {
        fs::remove_dir_all(work_dir)?;
    }
    if fs::exists(pkg_dir)? {
        fs::remove_dir_all(pkg_dir)?;
    }

    Ok(())
}

fn download_file(url: &str) -> anyhow::Result<String> {
    let filename = url.split('/').last().unwrap();
    let filepath = format!("{}/{}", SOURCE_DIR, filename);

    if !fs::exists(&filepath)? {
        run_command("wget", &[url, "-P", SOURCE_DIR])?;
    }

    Ok(filepath)
}

fn download_sources(pkg: &PackageFile) -> anyhow::Result<(String, Vec<String>, Vec<String>)> {
    let source_path = download_file(&pkg.prepare.source.url)?;

    let mut additional_paths = Vec::new();
    for additional in &pkg.prepare.additionals {
        let path = download_file(&additional.url)?;
        additional_paths.push(path);
    }

    let mut patch_paths = Vec::new();
    for patch in &pkg.prepare.patches {
        let path = download_file(&patch.url)?;
        patch_paths.push(path);
    }

    Ok((source_path, additional_paths, patch_paths))
}

fn extract_file(work_dir: &str, path: &str) -> anyhow::Result<()> {
    run_command(
        "tar",
        &["-xf", path, "-C", work_dir, "--strip-components=1"],
    )?;

    Ok(())
}

fn extract_source(work_dir: &str, source: String) -> anyhow::Result<()> {
    run_command("mkdir", &["-p", work_dir])?;

    extract_file(work_dir, &source)?;
    Ok(())
}

fn copy_additional_files(work_dir: &str, additionals: Vec<String>) -> anyhow::Result<()> {
    for additional in additionals {
        run_command("cp", &["-r", &additional, work_dir])?;
    }

    Ok(())
}

fn apply_patches(
    work_dir: &str,
    current_dir: &str,
    patches: Vec<String>,
    patch_strip: usize,
) -> anyhow::Result<()> {
    for patch in patches {
        run_command(
            "sh",
            &[
                "-c",
                &format!(
                    "cd {} && patch -Np{} -i {}/{}",
                    work_dir, patch_strip, current_dir, &patch
                ),
            ],
        )?;
    }

    Ok(())
}

fn run_steps(
    work_dir: &str,
    steps: Vec<String>,
    envs: HashMap<String, String>,
) -> anyhow::Result<()> {
    for step in steps {
        run_command_with_envs(
            "sh",
            &["-c", &format!("cd {} && {}", work_dir, step)],
            &envs,
        )?;
    }

    Ok(())
}

fn copy_work_dir(src: &str, dest: &str) -> anyhow::Result<()> {
    run_command("cp", &["-r", src, dest])?;

    Ok(())
}

fn write_metadata(metadata: &Metadata, pkg_dir: &str) -> anyhow::Result<()> {
    let metadata_file = format!("{}/METADATA", pkg_dir);
    let metadata_yaml = serde_yaml::to_string(&metadata)?;
    fs::write(&metadata_file, metadata_yaml)?;

    Ok(())
}

fn get_package_archive_path(metadata: &Metadata, current_dir: &str) -> String {
    let dist_dir = format!("{}/{}", current_dir, DIST_DIR);

    format!(
        "{}/{}-{}-{}.tar.zst",
        dist_dir, metadata.name, metadata.version, metadata.release
    )
}

fn create_archive(metadata: &Metadata, pkg_dir: &str, current_dir: &str) -> anyhow::Result<()> {
    let dist_dir = format!("{}/{}", current_dir, DIST_DIR);
    create_dir_all(&dist_dir)?;

    let path = get_package_archive_path(metadata, current_dir);
    run_command(
        "tar",
        &["-I", "zstd -T0 -19", "-cf", &path, "-C", pkg_dir, "."],
    )?;

    Ok(())
}

pub fn build_package(package: &str) -> anyhow::Result<()> {
    let current_dir = std::env::current_dir()?.to_string_lossy().to_string();

    let pkg = get_pkgfile(package)?;
    let (work_dir, pkg_dir) = get_dirs(package)?;
    cleanup(&work_dir, &pkg_dir)?;

    for package in &pkg.packages {
        let path = get_package_archive_path(&package.meta, &current_dir);
        if fs::exists(path)? {
            println!("Skip building packages");
            return Ok(());
        }
    }

    let (source, additionals, patches) = download_sources(&pkg)?;
    extract_source(&work_dir, source)?;
    copy_additional_files(&work_dir, additionals)?;
    apply_patches(&work_dir, &current_dir, patches, pkg.prepare.patch_strip)?;

    run_steps(&work_dir, pkg.prepare.steps, pkg.prepare.envs)?;
    run_steps(&work_dir, pkg.build.steps, pkg.build.envs)?;
    run_steps(&work_dir, pkg.test.steps, pkg.test.envs)?;

    for package in pkg.packages {
        let package_work_dir = format!("{}-{}", work_dir, package.meta.name);
        let package_pkg_dir = format!("{}-{}", pkg_dir, package.meta.name);

        cleanup(&package_work_dir, &package_pkg_dir)?;

        copy_work_dir(&work_dir, &package_work_dir)?;
        create_dir_all(&package_pkg_dir)?;

        let mut envs = package.envs;
        envs.insert("out".to_string(), pkg_dir.clone());

        run_steps(&package_work_dir, package.steps, envs)?;

        write_metadata(&package.meta, &package_pkg_dir)?;

        create_archive(&package.meta, &package_pkg_dir, &current_dir)?;

        cleanup(&package_work_dir, &package_pkg_dir)?;
    }
    cleanup(&work_dir, &pkg_dir)?;

    Ok(())
}
