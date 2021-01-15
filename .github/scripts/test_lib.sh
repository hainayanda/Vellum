set -eo pipefail

xcodebuild -workspace Example/Vellum.xcworkspace \
            -scheme Vellum-Example \
            -destination platform=iOS\ Simulator,OS=14.3,name=iPhone\ 11 \
            clean test | xcpretty
