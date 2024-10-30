 #!/usr/bin/env bash
 if [ ! -x /opt/hayabusa/README.md ]; then
      URL=$(curl -s https://api.github.com/repos/yamato-security/hayabusa/releases/latest | grep "browser_download_url" | grep "lin-x64-gnu" | sed 's/.*: "//' | rev | cut -c2- | rev)  && wget $URL -O /tmp/hayabusa.zip
      set +e
      unzip /tmp/hayabusa.zip -d /opt/hayabusa
      set -e
      rm /tmp/hayabusa.zip
    
      chmod +x /opt/hayabusa/hayabusa*x64-gnu
      /opt/hayabusa/hayabusa*x64-gnu update-rules
      
      mv /tmp/hayabusa-wrapper.sh /usr/local/bin/hayabusa-wrapper.sh
      chmod +x /usr/local/bin/hayabusa-wrapper.sh
  fi