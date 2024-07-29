class IntroHelper {
  getImage(int i) {
    return 'assets/images/intro${i + 1}.png';
  }

  geTitle(int i) {
    List title = ["Haar knippen", "Honden trimmer", "Reparatie diensten"];
    return title[i];
  }

  geSubTitle(int i) {
    List subTitle = [
      "Laat je haar knippen door een van onze professionals",
      "Boek een knipbeurt voor je liefste viervoeter",
      "Laat je huis repareren door een van onze reparatie professionals"
    ];
    return subTitle[i];
  }
}
