#!/bin/bash
# Make Slack Black (from v.4.0.0)

# Install Asar if not available on local machine
npm list | grep asar > /dev/null || npm install asar --no-shrinkwrap

# Copy app.asar and app.asar.unpacked from Slack.app
mkdir -p ~/tmp/slack
cp /Applications/Slack.app/Contents/Resources/app.asar ~/tmp/slack
cp -r /Applications/Slack.app/Contents/Resources/app.asar.unpacked ~/tmp/slack

# Extract Asar
cd ~/tmp/slack
asar extract app.asar app

script="document.addEventListener('DOMContentLoaded', function() {    
  fetch('https://cdn.rawgit.com/laCour/slack-night-mode/master/css/raw/black.css')    
  .then(function(response) {
    return response.text();
  })
  .then(function(css) {
    const style = document.createElement('style'); 
    style.innerHTML = css;
    document.head.appendChild(style);
  });
});"

# Inject script into bundle
echo $script | cat - app/dist/ssb-interop.bundle.js > /tmp/out && mv /tmp/out app/dist/ssb-interop.bundle.js

# Pack Asar
asar pack app app.asar

# Copy packed Asar
sudo cp app.asar /Applications/Slack.app/Contents/Resources

