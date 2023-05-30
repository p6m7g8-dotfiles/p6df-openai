# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::kaggle::deps()
#
#>
######################################################################
p6df::modules::kaggle::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6df-jupyter
  )
}

######################################################################
#<
#
# Function: p6df::modules::kaggle::langs()
#
#>
######################################################################
p6df::modules::kaggle::langs() {

  pip install kaggle

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::kaggle::clones()
#
#  Environment:	 P6_DFZ_SRC_FOCUSED_DIR
#>
######################################################################
p6df::modules::kaggle::clones() {

  p6_github_login_clone "Kaggle" "$P6_DFZ_SRC_FOCUSED_DIR"

  p6_return_void
}

p6df::modules::kaggle::prompt::line() {
  local kaggle_username="$KAGGLE_USERNAME"
  local kaggle_key="$KAGGLE_KEY"
  local str="kaggle: "

  if [ -n "$kaggle_username" ]; then
    str+="($kaggle_username)"
  fi

  # Add Kaggle CLI integration
  if [ -n "$kaggle_key" ]; then
    local kaggle_cli_output
    kaggle_cli_output=$(kaggle config view 2>/dev/null)
    if [ $? -eq 0 ]; then
      local kaggle_cli_username
      kaggle_cli_username=$(echo "$kaggle_cli_output" | awk '/username/ { print $3 }' | tr -d '[:space:]')
      if [ -n "$kaggle_cli_username" ]; then
        str+=" (cli: $kaggle_cli_username)"
      fi
    fi
  fi

  p6_return_str "$str"
}

# export KAGGLE_USERNAME=datadinosaur
# export KAGGLE_KEY=xxxxxxxxxxxxxx
# kaggle competitions {list, files, download, submit, submissions, leaderboard}
# kaggle datasets {list, files, download, create, version, init}
# kaggle kernels {list, init, push, pull, output, status}
# kaggle config {view, set, unset}
