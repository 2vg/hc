#!/usr/bin/env -S cargo +nightly -q -Zscript run --release --manifest-path
```cargo
[package]
name = "hc"
version = "1.0.0"
edition = "2021"
[dependencies]
anyhow = { version = "1.0" }
clap = { version = "4.5.1", features = ["derive"] }
holiday_jp = { git = "https://github.com/holiday-jp/holiday_jp-rust", tag = "0.3.0" }
time = { version = "0.3.34", features = ["std", "local-offset"] }
```

use anyhow::*;
use clap::Parser;
use holiday_jp::HolidayJp;
use time::{OffsetDateTime, Weekday};

use std::process::exit;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[clap(short, long, help = "Includes Saturday and Sunday as holiday.")]
    includes_weekend: bool,
    #[clap(
        short,
        long,
        help = "Handle as holiday only Saturday and Sunday. This option will be ignored --includes_weekend."
    )]
    only_weekend: bool,
    #[clap(
        short,
        long,
        help = "Use UTC offset to check current date instead of the Local offset."
    )]
    utc: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let now = if args.utc {
        OffsetDateTime::now_utc()
    } else {
        OffsetDateTime::now_local()?
    }
    .date();
    let holiday = HolidayJp::is_holiday(now);
    let is_weekend = now.weekday() == Weekday::Saturday || now.weekday() == Weekday::Sunday;

    let should_exit = if args.includes_weekend {
        (holiday && is_weekend)
    } else {
        holiday
    } || (args.only_weekend && is_weekend);

    if should_exit {
        exit(0);
    } else {
        exit(1);
    }
}
