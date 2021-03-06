{ stdenv, buildPythonPackage, fetchFromGitHub, pkgs }:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.5a2";

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "pivy";
    rev = version;
    sha256 = "1w03jaha36bjyfaz8hchnv8yrkm5715w15crhd3qrlagz8fs38hm";
  };

  nativeBuildInputs = with pkgs; [
    swig qt5.qmake cmake
  ];

  buildInputs = with pkgs; with xorg; [
    coin3d soqt qt5.qtbase
    libGLU_combined
    libXi libXext libSM libICE libX11
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${pkgs.qt5.qtbase.dev}/include/QtCore"
    "-I${pkgs.qt5.qtbase.dev}/include/QtGui"
    "-I${pkgs.qt5.qtbase.dev}/include/QtOpenGL"
    "-I${pkgs.qt5.qtbase.dev}/include/QtWidgets"
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \$'{SoQt_INCLUDE_DIRS}' \
      \$'{Coin_INCLUDE_DIR}'\;\$'{SoQt_INCLUDE_DIRS}'
  '';

  meta = with stdenv.lib; {
    homepage = http://pivy.coin3d.org/;
    description = "A Python binding for Coin";
    license = licenses.bsd0;
  };

}
