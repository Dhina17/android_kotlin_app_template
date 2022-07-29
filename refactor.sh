set -e

# Config
TEMPLATE_PACKAGE="io.github.dhina17.template"
TEMPLATE_APP_NAME="Template"

ROOT_DIR="."
APP_DIR="$ROOT_DIR/app"
APP_SRC_DIR="$APP_DIR/src/main"
KOTLIN_SRC_DIR="$APP_SRC_DIR/kotlin"
TEMPLATE_PACKAGE_DIR="$KOTLIN_SRC_DIR/io/github/dhina17/template"

## Refactor the project name and package
# Read the app name
read -rp "Enter app name (ex: Notes): " NEW_APP_NAME

# Read the package name
read -rp "Enter package name (ex: io.github.dhina17.notes): " NEW_PACKAGE

# Create the package
NEW_PACKAGE_DIR="$KOTLIN_SRC_DIR/$(echo "$NEW_PACKAGE" | sed 's/\./\//g')"
mkdir -p "$NEW_PACKAGE_DIR"

# Copy the template source files to new package
cp -r $TEMPLATE_PACKAGE_DIR/. "$NEW_PACKAGE_DIR"

# Remove the template package and files
rm -rf $TEMPLATE_PACKAGE_DIR

# Change the package references in src
find $APP_DIR -type f -not -path '*/\.*' -exec sed -i "s/$TEMPLATE_PACKAGE/$NEW_PACKAGE/g" {} \;

# Change the app name references in all files
find $ROOT_DIR -type f -not -path '*/\.*' -not -path '*.sh' -exec sed -i "s/$TEMPLATE_APP_NAME/$NEW_APP_NAME/g" {} \;
