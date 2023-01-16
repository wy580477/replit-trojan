{ pkgs }: {
    deps = [
        pkgs.qrencode.bin
        pkgs.busybox
        pkgs.bashInteractive
        pkgs.man
    ];
}