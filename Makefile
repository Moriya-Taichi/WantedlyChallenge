all:
	Carthage update --no-use-binaries --platform iOS	
	cd Carthage/Checkouts/ReactorKit && swift package generate-xcodeproj
	cd Carthage/Checkouts/WeakMapTable && swift package generate-xcodeproj
	carthage build --platform iOS ReactorKit
	carthage build --platform iOS WeakMapTable