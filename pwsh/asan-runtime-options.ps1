# Set ASan runtime options
$env:ASAN_OPTIONS = "verbosity=1,log_path=asan.log,detect_leaks=0,strict_string_checks=1,fast_unwind_on_malloc=0"
