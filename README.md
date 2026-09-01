# Dotfiles

Personal Apple Silicon Mac configuration for user `mads`.

## Stack

- **Nix + Home Manager** — CLI tools, shell configuration, user launch agents, and managed links
- **Homebrew + MAS** — GUI applications, fonts, and Mac App Store applications
- **mise** — language runtimes and personal ecosystem CLIs
- **Worktrunk** — personal worktree UX only

## First-time setup

Install the Xcode Command Line Tools, wait for installation to finish, then clone over HTTPS and run the bootstrap:

```bash
xcode-select --install
/usr/bin/git clone https://github.com/madeleineostoja/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap.sh
```

`bootstrap.sh` requires macOS on Apple Silicon, user `mads`, `/Users/mads`, a completed CLT installation, and this repository at `~/dotfiles`. It installs Homebrew and Determinate Nix only when absent, applies the locked Home Manager configuration, reconciles Brew and MAS, installs mise tools, applies macOS defaults, enables the repository hook, and starts GitHub HTTPS authentication.

Home Manager conflicts are saved with a timestamped `home-manager-backup-*` suffix; review those files before deleting them. Homebrew environment setup is managed in Home Manager's Zsh profile—bootstrap never modifies `~/.zprofile`.

## Complete after bootstrap

### Accounts and authentication

On the first run, bootstrap opens the Mac App Store and waits for you to sign in and purchase any paid Brewfile applications before MAS installs them. Complete the browser flow from `gh auth login`; it uses HTTPS, so an SSH key is not required for initial setup. Verify authentication:

   ```bash
   gh auth status
   git remote -v
   ```

MAS application IDs live in `Brewfile`. To discover an ID for a new app, use `mas search "App Name"`, then add a `mas "App Name", id: ID` entry. Do not add AdGuard or Hush: Wipr 2 is the content blocker.

### Safari extensions

Open Safari → Settings → Extensions and manually enable Wipr 2, Sink It for Reddit, and Noir. Grant any per-extension website permissions there; installation alone does not activate an extension.

### Privacy, trust, and GUI permissions

- **Hyperkey** — grant Accessibility permission and enable “Caps Lock as Hyper”.
- **Hammerspoon** — grant Accessibility permission and enable Launch at Login. Its configuration loads automatically.
- **Rectangle** — grant Accessibility permission and enable Launch at Login.
- **BetterDisplay** — grant the permissions it requests and enable Launch at Login as needed. Do not use MonitorControl.
- **Pearcleaner** — enable Sentinel in its settings, then use Remaining Files for occasional orphan cleanup.
- **Time Machine** — add a backup disk and exclude `~/Code`, `~/.cache`, `/nix`, `/nix/store`, and `~/Library/Caches`.

Create three Spaces in Mission Control, then configure these shortcuts in System Settings → Keyboard → Keyboard Shortcuts:

| Action | Binding | Section |
| --- | --- | --- |
| Switch to Desktop 1–3 | Hyper+1–3 | Mission Control |

Pi asks before trusting projects and Zed does not trust all worktrees. Before using Worktrunk, open `~/Code` as the parent directory in each application and trust it once; current and future worktrees below that directory then share the intended parent trust boundary.

## Maintenance

### Weekly

Home Manager manages a `home-manager-auto-expire` launch agent. It expires Home Manager generations older than 30 days and garbage-collects unreachable user-store paths weekly. macOS keeps Nix `auto-optimise-store` disabled.

### Quarterly

```bash
sysupdate
```

This runs the complete updater:

1. Homebrew/cask/MAS update, upgrade, and reconciliation
2. Nix input update
3. Home Manager switch
4. `mise install`
5. `mise upgrade`
6. Best-effort `nix store optimise`

Review and commit dependency updates afterward:

```bash
cd ~/dotfiles
git diff flake.lock
git commit -am "chore: quarterly update"
git push
```

### Command boundaries

- `appsync` reconciles the Brewfile's Homebrew and MAS declarations and cleans stale Homebrew artifacts.
- `nixsync` applies the current locked Home Manager configuration without changing `flake.lock`.
- `sysupdate` is the complete quarterly updater above.

To roll back a Home Manager generation without updating inputs:

```bash
home-manager switch --rollback
```

## Common operations

**Add a native CLI tool:** add it to `home.packages` in `home.nix`, or use its Home Manager module in `modules/shell.nix`, then run `nixsync`.

**Add a global language runtime or personal ecosystem CLI:** edit `programs.mise.globalConfig` in `modules/shell.nix`, then run `nixsync`.

**Add a GUI or App Store app:** add a `cask` or `mas` entry to `Brewfile`, then run `appsync`.

**Add a configuration file:** create it under `configs/`, add an out-of-store link in `home.nix`, then run `nixsync`. Changes to out-of-store linked files are live immediately, but Home Manager rollback cannot roll those edits back.

**Try a tool ephemerally:**

```bash
nix shell nixpkgs#whatever
```

**Inspect Home Manager changes:**

```bash
home-manager generations
nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager
```

## Ownership boundaries

Workstation tools such as `bat`, `ripgrep`, `fd`, `fzf`, `mas`, and `shellcheck` belong in Nix. Node, pnpm, Python, and personal npm CLIs belong in mise. A repository's build, test, and runtime tooling belongs in that repository's `devDependencies`.

Databases, queues, Redis-like services, and other stateful development services are never host installs. Repositories own them through platform simulators, disposable remote resources, or project-scoped OrbStack containers. Worktrunk creates worktrees only; repositories must work the same with a plain `git worktree add`.

## Linting and recovery

The repository hook calls the same checks available manually:

```bash
./scripts/lint.sh
```

It checks Nix formatting and evaluation, Bash syntax and ShellCheck, strict JSON, plist validity, and trailing whitespace. Bootstrap configures the repository-local `core.hooksPath` to `.githooks`.

Useful verification and recovery commands:

```bash
nix eval --no-write-lock-file .#homeConfigurations.mads.activationPackage.drvPath
brew bundle check --file=~/dotfiles/Brewfile
mas list
home-manager switch --rollback
```

## Forking for work

```bash
git clone https://github.com/USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
git remote add upstream https://github.com/madeleineostoja/dotfiles.git

git fetch upstream
git merge upstream/main
git push
```

Adapt the personal identity, Home Manager username/home directory, Git identity, and any work-specific applications before applying a fork.
