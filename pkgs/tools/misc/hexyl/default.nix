{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname   = "hexyl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0aj2sysl0spf5zlcd5kfzlw97w7dzf9x93pv0d1v9blnbd1rz7lm";
  };

  cargoSha256 = "08hn0csw12xaag95gb5rj4q7k2zyy9j9bf4iw3b0r3ndh66qqra2";

  meta = with lib; {
    changelog = "https://github.com/sharkdp/hexyl/releases/tag/v${version}";
    description = "A command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage    = "https://github.com/sharkdp/hexyl";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
