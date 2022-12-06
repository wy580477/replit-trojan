{ pkgs }: {
    deps = [
        pkgs.jq.bin
        pkgs.busybox
        pkgs.bashInteractive
        pkgs.man
    ];
}