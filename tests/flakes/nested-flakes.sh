# Test that flakes in nested directories do not copy parent directories to the store.
source ./common.sh

requireGit

parentRepo=$TEST_ROOT/repo
createGitRepo $parentRepo

flakeDir = $parentRepo/flake
createSimpleGitFlake $flakeDir

# nix flakes cannot contain fifos. If the parent git repo is copied, this command will cause flake evaluation to fail.
# 
fifo = $parentRepo/fifo

# make sure file that will become fifo is known by git
touch $fifo
git -C $parentRepo add $fifo
rm $fifo
mkfifo $fifo

[[ $(nix eval $flakeDir) = 123 ]]



