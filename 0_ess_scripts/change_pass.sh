#!/bin/bash

#install git 
dnf install git -y 

# Set password
echo "ec2-user:DevOps321" | chpasswd

# Enable password authentication
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

systemctl restart sshd

# Create bashrc.d
mkdir -p /home/ec2-user/.bashrc.d

# Add source block to .bashrc
cat <<'EOF' >> /home/ec2-user/.bashrc

for file in ~/.bashrc.d/*.sh; do
    [ -r "$file" ] && source "$file"
done

EOF

# Create prompt script
cat <<'EOF' > /home/ec2-user/.bashrc.d/terminal_prompt.sh
# Load git prompt from RedHat/Amazon Linux OR Ubuntu/Debian locations
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
    source /usr/lib/git-core/git-sh-prompt
fi

PS1='\[\e[1;32m\]\u\
\[\e[0m\]@\[\e[1;33m\]\h\
\[\e[0m\]:\[\e[1;34m\]\w\
\[\e[35m\]$(__git_ps1 "   %s")\
\[\e[0m\]\n\
\[\e[1;32m\]❯ \[\e[0m\]'

PROMPT_COMMAND='printf "\n"'
EOF

# Ownership
chown -R ec2-user:ec2-user /home/ec2-user