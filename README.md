# Dotfiles

Personal Mac configuration

## Stack

- **Nix + Home Manager** — CLI tools, shell configuration, user launch agents, and managed links
- **Homebrew + MAS** — GUI applications, fonts, and Mac App Store applications
- **mise** — language runtimes and personal ecosystem CLIs

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
sys update
```

This runs the complete updater:

1. Homebrew/cask/MAS update, upgrade, and reconciliation
2. Nix input update
3. Home Manager switch
4. `mise install`
5. `mise upgrade`

`flake.lock` is local and ignored. Bootstrap creates it with current inputs, ordinary rebuilds retain those local pins, and `sys update` advances them without creating repository changes.

### On demand

```bash
sys cleanup
```

This removes stale Homebrew artifacts and cache files, then optimises the Nix store. The first Nix optimisation can take several minutes.

### Command boundaries

- `sys sync` reconciles applications, updates the `agents` input in `flake.lock`, and applies the Home Manager configuration.
- `sys sync --apps` reconciles only the Brewfile's Homebrew and MAS declarations.
- `sys sync --nix` updates only the `agents` input and applies Home Manager.
- `sys update` updates every Nix input as part of the complete quarterly updater above.
- `sys cleanup` reclaims disk space without updating or reconciling dependencies.

To roll back a Home Manager generation without updating inputs:

```bash
home-manager switch --rollback
```

## Common operations

**Add a native CLI tool:** add it to `home.packages` in `home.nix`, or use its Home Manager module in the relevant file under `modules/`, then run `sys sync --nix`.

**Add a global language runtime or personal ecosystem CLI:** edit `programs.mise.globalConfig` in `modules/mise.nix`, then run `sys sync --nix`.

**Add a GUI or App Store app:** add a `cask` or `mas` entry to `Brewfile`, then run `sys sync --apps`.

**Add a configuration file:** create it under `configs/`, add an out-of-store link in `home.nix`, then run `sys sync --nix`. Changes to out-of-store linked files are live immediately, but Home Manager rollback cannot roll those edits back.

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
