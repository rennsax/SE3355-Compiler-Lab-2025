#ifndef TIGER_COMPILER_OUTPUT_H
#define TIGER_COMPILER_OUTPUT_H

#include <string>

namespace output {

class AssemGen {
public:
  AssemGen() = delete;
  explicit AssemGen(std::string_view infile) {
    std::string outfile = static_cast<std::string>(infile) + ".s";
    out_ = fopen(outfile.data(), "w");
    filename = static_cast<std::string>(infile);
  }
  explicit AssemGen(std::string_view infile, std::string_view outfile)
      : filename(infile), out_(fopen(outfile.data(), "w")) {}
  explicit AssemGen(std::string_view infile, FILE *out): filename(infile), out_(out) {}
  AssemGen(const AssemGen &assem_generator) = delete;
  AssemGen(AssemGen &&assem_generator) = delete;
  AssemGen &operator=(const AssemGen &assem_generator) = delete;
  AssemGen &operator=(AssemGen &&assem_generator) = delete;
  ~AssemGen() { fclose(out_); }

  /**
   * Generate assembly
   */
  void GenAssem(bool need_ra);

  void LoadllvmAndGen(bool need_ra);

private:
  FILE *out_; // Instream of source file
  std::string filename;
};

} // namespace output

#endif // TIGER_COMPILER_OUTPUT_H
