{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "26";
        pnpm = "11";
        python = "latest";
        "npm:sentry" = "latest";
        "npm:@earendil-works/pi-coding-agent" = "latest";
      };
    };
  };
}
