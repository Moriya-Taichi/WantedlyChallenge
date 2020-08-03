if which mint >/dev/null; then 
    mint run swiftlint autocorrect --format
    mint run swiftlint
else
    echo "Please Install Mint"
fi
