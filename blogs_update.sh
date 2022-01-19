# @AikenHone 2021 using script to Update Blogs
# Enter the right dir
# We need to excute gitbook serve int terminal first
cd _book

# using condtional rules to control the update actions
if [ -d ".git" ];then
  echo "exist git files"
else
  git init
  git remote add origin git@github.com:AikenH/Docs.git
  echo "add remote repo relation"
fi

# update those blogs using git
git add .
git commit -m "update those blogs"
echo "update the local git log"

# push the update to the remote repo
git push -f origin master:gh-pages
echo "finish pushing files"
