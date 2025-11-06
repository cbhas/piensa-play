// lib/features/onboarding/domain/usecases/get_avatars.dart

import '../entities/avatar.dart';

class GetAvatars {
  List<Avatar> execute() {
    return [
      const Avatar(
        id: 'cocodrilo',
        assetPath: 'assets/avatars/cocodrilo.png',
        name: '',
      ),
      const Avatar(
        id: 'pajaro',
        assetPath: 'assets/avatars/pajaro.png',
        name: '',
      ),
      const Avatar(
        id: 'jaguar',
        assetPath: 'assets/avatars/jaguar.png',
        name: '',
      ),
      const Avatar(
        id: 'tortuga',
        assetPath: 'assets/avatars/tortuga.png',
        name: '',
      ),
    ];
  }
}
