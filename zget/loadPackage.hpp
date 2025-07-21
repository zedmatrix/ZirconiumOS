#include <string>
#include <print>
#include <map>
#include <fstream>
#include <filesystem>

constexpr char START_DELIM = '[';
constexpr char END_DELIM = ']';

bool loadPackage(std::map<std::string, std::string>& map, std::filesystem::path filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) return false;
    std::string line;
    std::string currentKey;
    std::string block;
    bool in_paren_block = false;
    int paren_depth = 0;

    while (std::getline(file, line)) {
        size_t eq_paren = line.find_first_of('=');
        if (!in_paren_block && eq_paren != std::string::npos) {
            currentKey = line.substr(0, eq_paren);
            //std::println("key:{}", currentKey);       //tester

            size_t open = line.find_first_of(START_DELIM, eq_paren);
            size_t close = line.find_last_of(END_DELIM);
            //std::println("key:{} open:{} close:{}", currentKey, open, close);     //tester

// One-liner: key=(value)
            if (close != std::string::npos) {
                block = line.substr(open + 1, close - open - 1);

                map[currentKey] = block;
                currentKey.clear();
                block.clear();
// Multi-line start
            } else {
                in_paren_block = true;

                paren_depth = 1;
                if (open != std::string::npos && open + 1 < line.size()) {
                    block = line.substr(open + 1) + "\n";
                } else {
                    block.clear();
                }

            }
            continue;
        }
        if (in_paren_block) {
            paren_depth += std::count(line.begin(), line.end(), START_DELIM);
            paren_depth -= std::count(line.begin(), line.end(), END_DELIM);

            if (paren_depth <= 0) {
                size_t close = line.find(END_DELIM);
                if (close != std::string::npos) {
                    block += line.substr(0, close) + "\n";
                } else {
                    block += line + "\n";
                }
                in_paren_block = false;
                if (!block.empty() && block.back() == '\n')
                    block.pop_back();
                map[currentKey] = block;
                block.clear();
                currentKey.clear();
            } else {
                block += line + "\n";

            }
        }
    }
    return true;
}
