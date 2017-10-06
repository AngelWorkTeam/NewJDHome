source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/JustinYangJing/MySpecs.git'

platform :ios, '8.0'
#use_frameworks!
target 'NJDHome' do

pod 'YTKKeyValueStore', '~> 0.1.2'
pod 'Bugly', '~> 2.4.0'
pod 'YYKit'
pod 'Masonry'
pod 'SDWebImage', '3.7.5'
pod 'AFNetworking', '~> 3.0'
pod 'BNRSDKLib'
pod 'SAMCategories'
pod 'ReactiveCocoa',    '~> 2.0'
pod 'MBProgressHUD'
pod 'MJRefresh'
pod 'MagicalRecord'
#pod 'Objection'
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-NJDHome/Pods-NJDHome-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end

inhibit_all_warnings!
