class Triqs < Formula
  desc "Toolbox for Research on Interacting Quantum Systems"
  homepage "https://triqs.ipht.cnrs.fr/"
  url "https://github.com/TRIQS/triqs/archive/1.4.tar.gz"
  sha256 "98378d5fb934c02f710d96eb5a3ffa28cbee20bab73b574487f5db18c5457cc4"
  head "https://github.com/TRIQS/triqs.git"

  # doi "10.1016/j.cpc.2015.04.023"
  # tag "quantumphysics"

  depends_on "cmake" => :build
  depends_on :mpi => :cxx
  depends_on "boost"
  depends_on "hdf5"
  depends_on "fftw"
  depends_on "gmp"
  depends_on "python"
  depends_on "pkg-config" => :run

  def install
    system "pip", "install", "--upgrade", "pip"
    system "pip", "install", "--upgrade", "mako"
    system "pip", "install", "--upgrade", "scipy"
    system "pip", "install", "--upgrade", "numpy"
    system "pip", "install", "--upgrade", "jupyter"
    system "pip", "install", "--upgrade", "--force-reinstall", "--no-binary=h5py", "h5py"
    system "pip", "install", "--upgrade", "--force-reinstall", "--no-binary=mpi4py", "mpi4py"

    ENV.cxx11

    args = %W[
      ..
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    mkdir "build" do
      system "cmake", *args
      ENV.deparallelize { system "make" }
      system "make", "test"
      system "make", "install"
    end

    chmod 0555, bin/"clang_parser.py"
    chmod 0555, bin/"cpp2doc_tools.py"
  end

  test do
    system "python -c 'import pytriqs'"
  end
end
