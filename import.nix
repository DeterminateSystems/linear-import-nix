{ stdenv
, fetchFromGitHub
, nodejs
, yarn
, nodePackages
, nodeDependencies
}:
stdenv.mkDerivation {
  name = "linear-import";

  src = fetchFromGitHub {
    owner = "linear";
    repo = "linear";
    rev = "5cc44ba1ae86170ad54b2b3a99981b34a2d779a9";
    sha256 = "sha256-0M9AhNZ5HmsVrsFVc0IxGXZEnelnEuqJEYCirxodSiM=";
  };

  postPatch = ''
    cd packages/import
  '';

  nativeBuildInputs = [
    nodejs
    yarn
  ];

  buildInputs = [
    nodePackages.typescript
  ];

  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"
    npm run build:rollup --no-update-notifier
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/importer/dist
    ln -s ${nodeDependencies}/lib/node_modules $out/share/importer/dist/node_modules
    cp -r dist $out/share/importer

    cat > $out/bin/importer <<EOF
    #!/usr/bin/env node
    require("$out/share/importer/dist/cli");
    EOF

    chmod +x $out/bin/importer
    patchShebangs $out/bin/importer
  '';
}
