### Terminal Commands (Outside tmux)

| Command | Description |
| :--- | :--- |
| `tmux new -s <name>` | Start a new session named `<name>`. |
| `tmux ls` | List all running sessions. |
| `tmux attach -t <name>` | Reattach to a running session. |
| `tmux a` | Attach to the last active session. |
| `tmux kill-session -t <name>` | Terminate a specific session. |
| `tmux kill-server` | Terminate all sessions and kill the background tmux server. |

### Session Controls (Inside tmux)

| Command | Description |
| :--- | :--- |
| `Ctrl + b then d` | Detach from session (leaves everything running in the background). |
| `Ctrl + b then s` | Open an interactive menu to switch between sessions. |
| `Ctrl + b then $` | Rename current session. |
| `Ctrl + b then :` | Open the tmux command prompt. |

### Window Controls (Tabs inside a session)

| Command | Description |
| :--- | :--- |
| `Ctrl + b then c` | Create a new window. |
| `Ctrl + b then n / p` | Go to next / previous window. |
| `Ctrl + b then 1–9` | Jump directly to window number. |
| `Ctrl + b then ,` | Rename current window. |
| `Ctrl + b then w` | Open visual list of all windows across all sessions. |
| `Ctrl + b then &` | Close current window. |

### Pane Controls (Splits inside a window)

| Command | Description |
| :--- | :--- |
| `Ctrl + b then %` | Split pane vertically (side-by-side) (or `|` with your custom config). |
| `Ctrl + b then "` | Split pane horizontally (top/bottom) (or `-` with your custom config). |
| `Ctrl + b then Arrow Keys` | Navigate between panes (or `h/j/k/l` with your custom config). |
| `Ctrl + b then z` | Toggle Zoom (maximize current pane; press again to restore). |
| `Ctrl + b then x` | Close/kill current pane. |
| `Ctrl + b then q` | Display pane numbers (press the number key to jump to that pane). |
| `Ctrl + b then { or }` | Swap current pane with previous / next pane. |
