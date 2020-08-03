setup:
	mint bootstrap
	mint run carthage update --no-use-binaries --platform iOS	
	cd Carthage/Checkouts/ReactorKit && swift package generate-xcodeproj
	cd Carthage/Checkouts/WeakMapTable && swift package generate-xcodeproj
	mint run carthage build --platform iOS ReactorKit
	mint run carthage build --platform iOS WeakMapTable
	mint run xcodegen generate
	touch .git/hooks/pre-commit
	touch .git/hooks/post-checkout
	cat .gitCheckoutHooks > .git/hooks/post-checkout
	cat .gitPreCommitHooks > .git/hooks/pre-commit
	chmod a+x .git/hooks/post-checkout
	chmod a+x .git/hooks/pre-commit