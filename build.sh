# ensures that we always use the latest version of the script
if [ -f build-site.sh ]; then
  rm build-site.sh
fi 


cd snooty && npm run build:no-prefix
