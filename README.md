# firebase-emulator-action

An action which starts the Firebase Emulator Suite.

## Usage

Prerequisites for this action:

- Node.js
- Java

To use the action, use the `firebase-emulator-action` action:

```yaml
steps:
  # Ensure Node.js is installed (See https://github.com/actions/setup-node)
  - name: Setup Node.js
    uses: actions/setup-node@v4
    with:
      node-version: 20

  # Ensure Java is installed (See https://github.com/actions/setup-java)
  - name: Setup Java
    uses: actions/setup-java@v4
    with:
      distribution: 'temurin'
      java-version: 17
  
  # Install the Firebase Emulator Suite
  - name: Start Firebase Emulator Suite
    uses: firebase-emulator-action@v1
    with:
      # Firebase CLI version to install, (`npm install -g firebase-tools@${firebase-tools-version}`)
      firebase-tools-version: 'latest'

      # Comma separated list of emulators to start. This example is the default:
      emulators: 'auth,firestore,functions,storage,database'

      # Project ID to use, defaults to 'test-project'.
      project-id: 'test-project'

      # Maximum attempted retries to before action fails, defaults to 3.
      max-retries: '3'

      # Maximum checks to perform before retry fails, defaults to 60.
      max-checks: '60'

      # Seconds to wait between checks, defaults to 1.
      wait-time: '1'

      # Port to check for emulator startup status, defaults to 9099 (Cloud Firestore).
      # Change this if you are using specific emulators or non-standard ports.
      # See https://firebase.google.com/docs/emulator-suite/install_and_configure#port_configuration.
      check-port: '9099'
```
