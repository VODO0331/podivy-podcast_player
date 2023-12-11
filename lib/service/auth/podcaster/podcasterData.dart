

class PodcasterData {
  final String name;
  final String imagePath;
  PodcasterData({required this.name, required this.imagePath});
  factory  PodcasterData.defaultPodcaster(){
    return PodcasterData(name: 'podcaster', imagePath: 'images/podcaster/defaultPodcaster.jpg');
  } 
}