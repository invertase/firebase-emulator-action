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
      java-version: '17'
  
  # Install the Firebase Emulator Suite
  - name: Start Firebase Emulator Suite
    uses: firebase-emulator-action@v1
    with:
      # The version of the Firebase CLI to install, (`npm install -g firebase-tools@${firebase-tools-version}`)
      firebase-tools-version: 'latest'

      # A comma separated list of emulators to start.
      emulators: 'auth,firestore,functions,storage,database'

      # The project ID to use, defaults to 'test-project'.
      project-id: 'test-project'

      # The maximum number of retries to attempt before failing the action, defaults to 3.
      max-retries: '3'

      # The maximum number of checks to perform before failing the retry, defaults to 60.
      max-checks: '60'

      # The time to wait between checks in seconds, defaults to 1.
      wait-time: '1'

      # The port to check for the emulators, defaults to 9099 (Cloud Firestore). Change this if you are using specific emulators. See https://firebase.google.com/docs/emulator-suite/install_and_configure#port_configuration.
      check-port: '9099'
```