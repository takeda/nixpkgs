import ./make-test.nix ({ pkgs, ... }: {
  name = "fish";

  machine =
    { pkgs, ... }:

    {
      programs.fish.enable = true;
      environment.systemPackages = with pkgs; [
        coreutils
        procps # kill collides with coreutils' to test https://github.com/NixOS/nixpkgs/issues/56432
      ];
    };

  testScript =
    ''
      $machine->waitForFile("/etc/fish/generated_completions/coreutils.fish");
      $machine->waitForFile("/etc/fish/generated_completions/kill.fish");
      $machine->succeed("fish -ic 'echo \$fish_complete_path' | grep -q '/share/fish/completions /etc/fish/generated_completions /root/.local/share/fish/generated_completions\$'");
    '';
})
