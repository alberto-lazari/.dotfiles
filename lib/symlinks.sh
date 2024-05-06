#!/usr/bin/env false

# Create symlink of the file
# usage: link_file FILE [-d] [-t TARGET_DIRECTORY] [LINK_NAME]
# options:
# -d, --as-dotfile    link as dotfile
# -t                  directory to put the link in (default: ~)
# LINK_NAME           custom name for the link, ignoring -d (default: FILE)
link_file () {
  local dotfiles_lib_dir
  local dotfile
  local target_dir
  local file
  local link_name
  local target_file
  local target_file_name
  local overwrite

  dotfiles_lib_dir="$(realpath "$(dirname "$BASH_SOURCE")")"

  [[ -n $DOTFILES_SILENT ]] || local DOTFILES_SILENT=false
  [[ -n $DOTFILES_VERBOSE ]] || local DOTFILES_VERBOSE=false
  [[ -n "$overwrite_file" ]] || local overwrite_file="$dotfiles_lib_dir/../.overwrite"
  dotfile=false

  . "$dotfiles_lib_dir/options.sh"

  parse_opts dt: "$@"
  set -- "${OPTS[@]-}"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d | --as-dotfile)
        dotfile=true;;
      -t) target_dir="$2"
        shift
        ;;
      *) echo lib/symlinks.sh: \'link_file\' function: bad usage >&2
        return 1
        ;;
    esac
    shift
  done

  # Read the file to link
  if [[ -n "${ARGS[0]}" ]]; then
    file="$(realpath "${ARGS[0]}")"
  else
    echo lib/symlinks.sh: \'link_file\' function: bad usage >&2
    return 1
  fi

  # Read the optional name of the link
  if [[ -n "${ARGS[1]}" ]]; then
    link_name="${ARGS[1]}"
  else
    link_name="$($dotfile && echo .)$(basename "$file")"
  fi
  target_file="${target_dir:-$HOME}/$link_name"
  target_file_name="$(sed "s|$HOME"'|~|' <<< "$target_file")"

  # Check that the file is not already linked
  [[ "$(realpath "$file")" != "$(realpath -q "$target_file")" ]] || {
    ! $DOTFILES_VERBOSE ||
      echo [=] Existing link skipped: $target_file_name
    return 0
  }

  # Link immediately if the target file does not exist
  if ! [[ -f "$target_file" || -L "$target_file" ]]; then
    $DOTFILES_SILENT ||
      echo [+] Creating link: $target_file_name
    ln -s "$file" "$target_file"
    return 0
  fi

  [[ -n "$DOTFILES_INSTALL" || -n "$DOTFILES_SETUP" ]] || {
    # Not called from an install or setup, file has to be initialized
    echo > "$overwrite_file"
  }

  overwrite=$(cat "$overwrite_file")
  # Check permissions to overwrite the existing file
  shopt -s nocasematch
  until [[ -n "$overwrite" && "$overwrite" = [ynad] ]]; do
    read -rp "[!] Existing file found. Overwrite \`$target_file_name\`? [y/N/a/d/?] " overwrite >&2

    case "$overwrite" in
      '') overwrite=N ;;
      [ad])
        # Keep trace of choice for all files
        echo $overwrite > "$overwrite_file"
        ;;
      \?) cat >&2 <<- EOF
				y - overwrite this file
				n - do not overwrite this file (default)
				a - overwrite all existing files
				d - do not overwrite any file
				? - print help

				EOF
        ;;
      [yn])
        # Do nothing, just a valid answer
        ;;
      *) echo $'You need to answer Y, N, A, D or `?` for help (default N)\n' >&2 ;;
    esac
  done

  case $overwrite in
    [ya])
      $DOTFILES_SILENT ||
        echo [!] Replacing file: $target_file_name
      ln -fs "$file" "$target_file"
      ;;
    [nd])
      $DOTFILES_SILENT ||
        echo [-] Skipping file: $target_file_name
      ;;
    *) echo lib/symlinks.sh: programming error >&2
      return 2
      ;;
  esac
  shopt -u nocasematch
}

# Create symlinks of files found in DIRECTORY except setup scripts
# usage: link_files_in DIRECTORY [-d] [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
# options:
# -d, --as-dotfile    link as dotfile
# -e                  exclude files (regex escaped)
# -t                  directory to put links in (default: ~)
link_files_in () {
  local dotfile
  local exclude
  local target_dir
  local dir
  local exclude
  local file

  [[ -n $DOTFILES_SILENT ]] || local DOTFILES_SILENT=false
  [[ -n $DOTFILES_VERBOSE ]] || local DOTFILES_VERBOSE=false
  dotfile=false

  . "$(dirname "$BASH_SOURCE")/options.sh"

  parse_opts de:t: "$@"
  set -- "${OPTS[@]}"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d | --as-dotfile)
        dotfile=true;;
      -e) exclude="$2"
        shift
        ;;
      -t) target_dir="$2"
        shift
        ;;
      *) echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
        return 1
        ;;
    esac
    shift
  done

  if [[ -n "${ARGS[0]}" ]]; then
    dir="$(realpath "${ARGS[0]}")"
  else
    echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
    return 1
  fi

  # Exclude sub-directories, setup scripts, readmes and explicitly excluded files
  exclude=".*/|setup|readme\.md${exclude+|$exclude}"
  file

  # Loop on every file in DIRECTORY, except the excluded ones
  for file in $(ls -p "$dir" | grep -Ewv "$exclude"); do
    link_file "$dir/$file" $($dotfile && echo -d) ${target_dir+-t "$target_dir"}
  done
}
