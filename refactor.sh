set -e

# Config
BASE_PACKAGE_ID="dev.dhina17"
TEMPLATE_PACKAGE="dev.dhina17.template"
TEMPLATE_APP_NAME="Template"
DEFAULT_MIN_SDK="21"

ROOT_DIR="."
APP_DIR="$ROOT_DIR/app"
APP_SRC_DIR="$APP_DIR/src/main"
KOTLIN_SRC_DIR="$APP_SRC_DIR/kotlin"
TEMPLATE_PACKAGE_DIR="$KOTLIN_SRC_DIR/dev/dhina17/template"

## Refactor the project name and package
# Read the app name
read -rp "Enter app name (ex: Notes): " NEW_APP_NAME

# Read the package name
read -rp "Enter package name (ex: dev.dhina17.notes): " NEW_PACKAGE

# Read the minimum SDK version
read -rp "Enter minimum SDK version (default: 21):" MIN_SDK
MIN_SDK="${MIN_SDK:=$DEFAULT_MIN_SDK}"

# Create the package
echo "Creating new package dir..."
NEW_PACKAGE_DIR="$KOTLIN_SRC_DIR/$(echo "$NEW_PACKAGE" | sed 's/\./\//g')"
mkdir -p "$NEW_PACKAGE_DIR"

# Copy the template source files to new package
echo "Copying the template source files..."
cp -r $TEMPLATE_PACKAGE_DIR/. "$NEW_PACKAGE_DIR"

# Remove the template package and files
echo "Removing the template package dir..."
rm -rf $TEMPLATE_PACKAGE_DIR

# Remove entire base package if it doesn't match with new package
if [[ $BASE_PACKAGE_ID != $(grep -o $BASE_PACKAGE_ID <<< $NEW_PACKAGE) ]]; then
    rm -rf $KOTLIN_SRC_DIR/io
fi

# Change the package references in src
echo "Updating the package references with new package..."
find $APP_DIR -type f -not -path '*/\.*' -exec sed -i "s/$TEMPLATE_PACKAGE/$NEW_PACKAGE/g" {} \;

# Change the app name references in all files
echo "Updating the app name references with new name..."
find $ROOT_DIR -type f -not -path '*/\.*' -not -path '*.sh' -exec sed -i "s/$TEMPLATE_APP_NAME/$NEW_APP_NAME/g" {} \;

# Update the app minimum SDK
echo "Updating the app minimum SDK with $MIN_SDK..."
sed -i "s/minSdkVersion 21/minSdkVersion $MIN_SDK/g" app/build.gradle

# Remove README
echo "Removing README.md..."
rm README.md

# Remove the LICENSE file (It's fine with unlicense)
echo "Removing LICENSE..."
rm LICENSE

# Final
echo "Done. Please sync the project manually!"
