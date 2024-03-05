# HC

**H**oliday **C**hecker

A tiny rust script that handles whether today is a holiday or not.

## description

This rust script can check today is jp-holiday or not.

If today is jp-holiday, script will be returned Exit(0), if not will be returned Exit(1).

Optionaly, script can include weekend.

Intended for use with a task scheduler like Cron.

> [!WARNING]
> Although this is a script but the contents are Rust, so the first time you run it or after changing the contents of the script, compilation will be performed, which will slow down the execution speed.

## install

require nightly Rust.

```
rustup install nightly
```

Then, copy this script to anywhere in ur PATH.

## usage

* run something if only jp-holiday

```sh
hc && something
```

* run something if only jp-holiday, but includes weekend

```sh
hc -- -i && something
```

* run something if only weekend

```sh
hc -- -o && something
```

* run something if only weekday(exclude holiday + weekend)

```sh
hc -- -i || something
```

* run something if only saturday

```txt:cron.txt
* * * * 6
```

* run something if only sunday

```txt:cron.txt
* * * * 0 or * * * * 7
```

* run something but if want to separate process depending on whether holiday or not

```sh
#!/bin/bash
hc
# if want to include weekend,
# use `hc -- -i`
if [ $? -eq 0 ]; then
  something_when_holiday
else
  something_when_not_holiday
fi
```
