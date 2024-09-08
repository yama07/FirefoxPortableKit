use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    // 各ファイル／ディレクトリのパスを作成
    // ------------------------
    // Firefox Portable.app/Contents
    // ├── Info.plist
    // ├── MacOS
    // │   └── firefox_launcher  // exe_path
    // └── Resources             // resources_path
    //    ├── Firefox.app        // firefox_app_path
    //    ├── firefox.icns
    //    └── Profile            // profile_path
    let exe_path = env::current_exe().expect("Failed to get current executable path");

    let resources_path = exe_path
        .parent()
        .and_then(|p| p.parent())
        .map(|p| p.to_path_buf())
        .map(|p| p.join("Resources"))
        .expect("Failed to construct Resources directory path");

    let firefox_app_path = PathBuf::from(&resources_path).join("Firefox.app");

    let profile_path = PathBuf::from(&resources_path).join("Profile");
    if !profile_path.exists() {
        std::fs::create_dir_all(&profile_path).expect("Failed to create Profile directory");
    }

    // Firefoxを実行
    let mut command = Command::new("open");
    command
        .arg("-n")
        .arg("-a")
        .arg(firefox_app_path)
        .arg("--args")
        .arg("--profile")
        .arg(profile_path);
    let args: Vec<String> = env::args().skip(1).collect();
    for arg in args {
        command.arg(arg);
    }

    command.spawn().expect("Failed to execute Firefox");
}
