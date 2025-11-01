use clap::Parser;
use fluxus_build::build_package;

#[derive(Debug, Parser)]
struct Cli {
    #[arg()]
    packages: Vec<String>,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    for package in cli.packages {
        build_package(&package)?;
    }

    Ok(())
}
