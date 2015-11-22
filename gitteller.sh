#!/usr/bin/env bash

# A git snippet to discover the parent branch of the current checked out branch.

guide() {
  URL='http://beyondgrep.com/install/'
  echo -ne "See this page for installation on your platform: $URL"
  echo ""
}

# Check Ack existence.
if hash ack 2>/dev/null; then
  current_branch=`git rev-parse --abbrev-ref HEAD`
  git show-branch -a | ack '\*' | ack -v "$current_branch" | head -n1 |  sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
else
  echo "Ack not found!"
  echo ""
  # Detect the platform.
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
      DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
      DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi

    if [ "$DISTRO" == "Ubuntu" ] || [ "$DISTRO" == "Debian" ]; then
      echo "Installing ack package..."
      echo ""
      sudo apt-get install ack-grep
      sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    guide
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    guide
  elif [[ "$OSTYPE" == "msys" ]]; then
    guide
  elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    guide
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    guide
  else
    echo "Unknow operating system! Sorry mate."
  fi
fi

