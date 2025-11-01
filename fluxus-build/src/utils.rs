use std::{
    collections::HashMap,
    io::{stderr, stdout},
    process::Command,
};

pub fn run_command(command: &str, args: &[&str]) -> anyhow::Result<()> {
    println!("{} {:?}", command, args);

    let output = Command::new(command)
        .args(args)
        .stderr(stderr())
        .stdout(stdout())
        .output()
        .map_err(|e| anyhow::anyhow!("Failed to execute command: {}", e))?;

    if !output.status.success() {
        anyhow::bail!(
            "Command failed with status code {}",
            output.status.code().unwrap_or(-1)
        );
    }

    Ok(())
}

pub fn run_command_with_envs(
    command: &str,
    args: &[&str],
    envs: &HashMap<String, String>,
) -> anyhow::Result<()> {
    let output = Command::new(command)
        .args(args)
        .stderr(stderr())
        .stdout(stdout())
        .envs(envs)
        .output()
        .map_err(|e| anyhow::anyhow!("Failed to execute command: {}", e))?;

    if !output.status.success() {
        anyhow::bail!(
            "Command failed with status code {}",
            output.status.code().unwrap_or(-1)
        );
    }

    Ok(())
}
