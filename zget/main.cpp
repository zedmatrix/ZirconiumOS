#include "loadPackage.hpp"
#include "download.hpp"

/*
 *  Global Definitions
*/
std::filesystem::path filePath, m_file;
std::filesystem::path m_srcdir = ("sources");

std::string m_pkgurl, m_result, m_pkgsum;
bool m_sha256 = false;

std::map<std::string, std::string> m_packageMap;
/*
 *  Function Definitions
*/
bool checkExist(const std::filesystem::path& filePath) {
    if (std::filesystem::exists(filePath)) {
        return true;
    }
    return false;
}
std::string getBaseName(const std::string& view) {
    std::string str(view);
    auto last_slash = str.find_last_of('/');
    if (last_slash != std::string::npos) {
        std::println("basename: {}", str.substr(last_slash + 1)); //test
        return str.substr(last_slash + 1);
    }
    return "";
}

std::string parseMap(const std::map<std::string, std::string>& map, const std::string& key) {
    auto it = map.find(key);
    if (it != map.end()) {
        return it->second;
    }
    return {};
}
int getPackage(const std::filesystem::path& filePath) {
    if (!checkExist(filePath)) {
        std::print(" Downloading: {} ", filePath.string());
        std::string tempSUM = download(m_pkgurl, filePath, m_sha256);

        if (tempSUM.empty() || tempSUM != m_pkgsum) {
            std::println("Failed To Download: {} \nChecksum Error:{}", filePath.string(), tempSUM);
            return 1;
        }
        std::println("Success");
    } else {
        std::println("File Exists: {}", filePath.string());
    }
    return 0;
}
int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::println("Error: Usage {} <Package File>", argv[0]);
        return 1;
    }
    std::filesystem::path fileName = argv[1];
    if (!std::filesystem::exists(fileName)) {
        std::println("Error: File Does Not Exist: {}", fileName.string());
        return 1;
    }
    if (std::filesystem::create_directory(m_srcdir)) {
        std::println("Directory: {} Created!", m_srcdir.string());
    }
    if (!loadPackage(m_packageMap, fileName)) {
        std::println("Error: Can Not Load: {}", fileName.string());
        return 1;
    }
    std::println("Map Size:{}", m_packageMap.size());
    for (auto& [key, value]: m_packageMap) {
        std::println("Key: {} Value: {}", key, value);
    }
    // Retrieve main package
    m_pkgsum = parseMap(m_packageMap, "md5sum");
    if (m_pkgsum.empty()) {
        m_sha256 = true;
        m_pkgsum = parseMap(m_packageMap, "sha256sum");
        if (m_pkgsum.empty()) {
            std::println("Missing Package Sum");
            return 1;
        }
    }
    if ((m_pkgurl = parseMap(m_packageMap, "pkgurl")).empty()) {
        std::println("No Package To Download");
    } else {
        m_file = getBaseName(m_pkgurl);
        int res = getPackage(m_srcdir / m_file);
    }
    // Retrieve patch
    if ((m_pkgurl = parseMap(m_packageMap, "patchurl")).empty()) {
        std::println("No Patch To Download");
    } else {
        m_pkgsum = parseMap(m_packageMap, "patchmd5");
        m_file = getBaseName(m_pkgurl);
        int res = getPackage(m_srcdir / m_file);
    }
    // Retrieve extra
    if ((m_pkgurl = parseMap(m_packageMap, "docurl")).empty()) {
        std::println("No Patch To Download");
    } else {
        m_pkgsum = parseMap(m_packageMap, "docmd5");
        m_file = getBaseName(m_pkgurl);
        int res = getPackage(m_srcdir / m_file);
    }

    return 0;
}
