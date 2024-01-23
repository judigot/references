Git:

Change parent branch; apply another branch's changes to another branch (switch to the branch you are working on):
 git rebase origin/feature/youre/working/on

Update feature branch with changes from the main branch:
 git merge origin/main

Run after installing Git:
Set main as initial branch, rather than master
git config --global init.defaultBranch main

Setup/Generate SSH key using git bash:

List all remote branches; list all branches:
 git branch -r

Push a new branch:
*-u is shorthsnd for --set-upstream
git push -u origin <new-branch>

Create and checkout to a new branch:
git checkout -b <new-branch>

# Create a new branch without files; Create a blank branch
```
git checkout --orphan <new-branch>
```

# Change commit message: change a commit message after pushing
```
git commit --amend -m "New commit message"
git push --force
git status
```


Rename a branch (must be in the branch you want to rename):
git branch -m <new-branch-name>

Upload a renamed brach to the repository:
git push origin HEAD:<renamed-branch>
 
Clone a repository to current folder:
  git clone <repository> .
  
Clone a repository to a named folder:
  git clone <repository> <folder name>

Merge a branch to production:
git checkout main
git merge <new-branch>

List all remote branches:
git branch -a

Create a new branch from an existing branch; create a new branch from an existing branch; create new branch from an existing branch:
git checkout -b new-branch parent-branch

Delete a local branch; delete local branch (checkout to another branch before deleting):
*checkout to another branch before deleting
*"Safe" delete (prevents you from deleting the branch if it has unmerged changes)
git branch -d <delete-this-branch>

Force delete a branch, even if it has unmerged changes
git branch -D <delete-this-branch>

Delete a remote branch:
git push origin -d <delete-this-branch>

Switch to another branch
git switch branch-to-use

Upload branch to remote
git add .
git commit -m "Commit"
git push -u origin <new-branch>
git status

Set Global Credentials:
git init
git config --global user.name "<username>"
git config --global user.email "<username>@github.com"

Set Local Credentials (on a specific project):
git init
git config user.name "<username>"
git config user.email "<username>@gmail.com"

Upload Project Folder Files/Override Repository:
git init
git add .
git commit -m "Commit"
git remote add origin https://github.com/<username>/repository
git remote -v
git push -f origin main
git status

Download Files/Repository:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git status
 
Revert back to main; hard reset; remove all changes:
```
git checkout target-branch
git fetch origin main
git pull origin main
git reset --hard origin/main
git push origin target-branch --force
```

Reset/remove all changes:
git stash -u

Reapply changes after resetting:
git stash pop

Remove stashes:
git stash drop

Save Changes:
git add .
git commit -m "Commit"
git push -f origin main
git status

Delete All Files:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git rm -r *
git commit -m "Delete"
git push -f origin main
git status

Delete Individual Files:
git init
git remote add origin https://github.com/<username>/repository
git pull origin main
git rm file.txt
git commit -m "Delete"
git push -f origin main
git status