#!/bin/bash
set -e

open_url() {
  url="$1"
  if command -v xdg-open &>/dev/null; then
    xdg-open "$url"
  elif command -v open &>/dev/null; then
    open "$url"
  elif command -v start &>/dev/null; then
    start "" "$url"
  elif command -v explorer.exe &>/dev/null; then
    explorer.exe "$url"
  elif command -v wslview &>/dev/null; then
    wslview "$url"
  else
    echo "❌ Cannot detect a command to open URLs on this system."
    return 1
  fi
}

# Check dependencies
if ! command -v fzf &>/dev/null; then
  echo "❌ fzf not installed."
  exit 1
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ Not a git repo."
  exit 1
fi

if command -v gh &>/dev/null; then
  gh_available=true
else
  echo "⚠️ gh CLI not found, skipping GitHub default branch update and browser open."
  gh_available=false
fi

current_branch=$(git symbolic-ref --short HEAD)
if [ "$current_branch" != "master" ]; then
  echo "⚠️ Not on master branch (on $current_branch), aborting."
  exit 1
fi

git branch -m master main
echo "✅ Local branch renamed to main"

remotes=$(git remote -v | awk '{print $1 "\t" $2}' | sort -u)
if [ -z "$remotes" ]; then
  echo "📁 No remotes found, exiting."
  exit 0
fi

selected=$(echo "$remotes" | fzf --prompt="Select remote > ")
if [ -z "$selected" ]; then
  echo "❌ No remote selected, aborting."
  exit 1
fi

remote_name=$(echo "$selected" | cut -f1)
remote_url=$(echo "$selected" | cut -f2)

echo "🔗 Selected remote: $remote_name"
echo "🔗 Remote URL: $remote_url"

git push -u "$remote_name" main
echo "📤 Pushed 'main' to remote $remote_name"

if [ "$gh_available" = true ]; then
  if [[ "$remote_url" =~ github\.com[/:]+([^/]+)/([^/.]+)(\.git)?$ ]]; then
    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"
    owner_repo="${owner}/${repo}"
    echo "🔍 Parsed GitHub repo: $owner_repo"
    echo "🌐 Opening GitHub repo settings page in browser..."
    open_url "https://github.com/$owner_repo/settings"
  else
    echo "⚠️ Could not parse GitHub repo URL to open settings page."
  fi
else
  echo "⚠️ gh CLI unavailable; please update default branch manually."
fi

echo "🎉 Done!"
