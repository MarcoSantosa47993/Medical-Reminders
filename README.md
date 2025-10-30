# Medicines Appointements Reminders

## Firebase Installation / Configuration

1. Go to Firebase and create a new project
2. In firebase activate authentication service
   2.1. Activate Email/Password authentication provider
   2.2. Don't activate email link (passwordless signin)
3. Activate Firestore database in test mode

## Configure Firebase in project

1. Install firebase-cli - https://firebase.google.com/docs/cli#setup_update_cli
2. Do firebase login

```bash
firebase login
```

3. Install the FlutterFire CLI by running the following command from any directory:

```bash
dart pub global activate flutterfire_cli
```

4. Use the FlutterFire CLI to configure your Flutter apps to connect to Firebase:

```bash

flutterfire configure
```

5. Select firebase project created previously

6. Keep selected all systems

7. Depois, corre os comandos:

```bash

flutter pub get
flutter run -d browser
```
