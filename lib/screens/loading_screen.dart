// // lib/screens/loading_screen.dart (enhanced version)
// import 'package:flutter/material.dart';

// class LoadingScreen extends StatelessWidget {
//   final String? message;
//   final String? subtitle;
  
//   const LoadingScreen({
//     Key? key,
//     this.message = 'Loading...',
//     this.subtitle = 'Please wait',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // App Logo or Icon
//             const FlutterLogo(size: 80),
//             const SizedBox(height: 30),
            
//             // Loading Indicator
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                 strokeWidth: 3,
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // Loading Text
//             Text(
//               message!,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
            
//             // Optional: Subtle text
//             if (subtitle != null) ...[
//               const SizedBox(height: 10),
//               Text(
//                 subtitle!,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Usage examples:
// // const LoadingScreen() - default loading
// // const LoadingScreen(message: 'Signing in...', subtitle: 'Authenticating') - custom message