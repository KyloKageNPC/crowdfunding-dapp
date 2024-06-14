import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:pixle_princess/pixle_princess.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixlePrincess game = PixlePrincess();
  runApp(GameWidget(game: kDebugMode ? PixlePrincess() : game));
}
