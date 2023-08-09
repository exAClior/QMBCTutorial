### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 0aae83c1-d0e7-435e-8446-164a2bdc9696
begin
	using Pkg
	Pkg.activate(".");
	Pkg.build("PyCall");
end

# ╔═╡ 9f9230a7-6900-42b3-a3c6-df303c9d9f39
begin
    using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ 697aee80-e7c9-4f27-9408-f44a2d835210
using Libdl

# ╔═╡ 36d487e3-f8a6-460d-98db-06e65b5dcd51
using PyCall

# ╔═╡ cd026a50-6e6c-4828-9880-548ea249451a
using BenchmarkTools

# ╔═╡ cfaa7ee8-8de8-4933-8396-0350408a14b4
begin 
	using Plots, Luxor
end

# ╔═╡ dd4ea4a2-9e06-43f7-976b-0c9af661cc8e
begin
    using Yao
    using KrylovKit
end

# ╔═╡ 0d49dbcd-b3d2-4965-b0b7-1de58f72025e
ChooseDisplayMode()

# ╔═╡ b47de57f-ee37-4a92-b99d-1a3763c31a3f
TableOfContents()

# ╔═╡ 0a2a79cc-9a37-4f96-b422-1a529d6a689b
html"""
	<h1 style="text-align:center">
		Julia for Quantum Many-Body Computation
	</h1>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			A Starter Kit
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Yusheng Zhao
		</p>
		<p style="font-size: 20px;">
			MinJiang University, Fu Zhou, 08/17/2023
		</p>
	</div>
"""

# ╔═╡ 3cd5a1aa-5229-43b1-8016-47903a1dae6f
md"
# Motivation
- What I cannot create, I do not understand -R.P Feynman 
![Feynman Quote](https://qph.cf2.quoracdn.net/main-qimg-87833c78a604ff07a82ff7787574e197.webp)
- What language to use?
"

# ╔═╡ 57684dc8-31f9-11ee-2888-770b687183aa
md"
# Why Julia?
## Short Answer
- Julia allows creation of **high performance** scientific computation code with **ease**!

## What is Julia?
- Julia is a **dynamic** programming language with the goal of being **easy to be made fast**.

### Dynamic
- Shallow learning curve
- Highly flexible 
- Low performance
- Two language problem
- When is vectorized code bad?
"

# ╔═╡ 1e84d230-2548-4da7-bc10-1ad2efcf14f4
function sumtil(n::Int)
	x = 0
	for i in 1:n
		x += i
	end
	return x
end

# ╔═╡ 7a2729c6-261f-498c-a3f7-f6ed0a383e0f
with_terminal() do
	# display the file
	run(`cat lib/demo.c`)
end

# ╔═╡ 57cc9fed-b719-45e1-8a66-92779275b4ed
run(`gcc lib/demo.c -fPIC -O3  -shared -o lib/demo.so`)

# ╔═╡ f45f49c5-597f-4be5-9359-3971d6cbf40e
c_sumtil(x) = Libdl.@ccall "lib/demo.so".c_sumtil(x::Csize_t)::Int

# ╔═╡ 5df12e78-bfb0-4806-9354-d17e277c4e63
begin
	py"""
	def sumtil(n):
		x = 0
		for i in range(1, n+1):
		    x += i
		return x
	"""
	@time py"sumtil"(10000000);
	@time sumtil(10000000);
	@time c_sumtil(10000000);
end

# ╔═╡ 0684f0b3-3030-4297-9d5b-026ff166ee1f
function naive_mc(Ntrials)
    Nhits = 0
    for _ in 1:Ntrials
        x, y = rand(), rand()
        if x^2 + y^2 <= 1
            Nhits += 1
        end
    end
    #println("π ≈ $(4*Nhits/Ntrials),I 💖 Julia")
end

# ╔═╡ e2633187-3b79-4c58-b2a3-8dc6d30b9b9c
@btime naive_mc(10^7)

# ╔═╡ bec0efb6-1f14-4e22-b01c-bbf992f29b52
md"
### Type Inference and Multiple Dispatch
- Computers are fast when it knows EXACTLY what to do
- Slowness of Dynamic language is related to cache miss.
- User defined type needs to conform to Julia type system
- Just ahead of time compiler: aggressively optimizes code based on runtime type info
- time to first plot
- Code introspect `@code_llvm` easy to spot your performance lagging
"



# ╔═╡ 69738959-95a3-46b4-9124-5db1160c1295
@drawsvg begin
	x0 = -50
	background("white")
	for i=1:4
		y0 = 40 * i - 100
		box(Point(x0, y0), 50, 40; action=:stroke)
		box(Point(x0+50, y0), 50, 40; action=:stroke)
		setcolor("#88CC66")
		circle(Point(x0+120, y0), 15; action=:fill)
		setcolor("black")
		Luxor.text("type", Point(x0, y0); halign=:center, valign=:center)
		Luxor.text("*data", Point(x0+50, y0); halign=:center, valign=:middle)
		Luxor.text("data", Point(x0+120, y0); halign=:center, valign=:middle)
		Luxor.arrow(Point(x0+50, y0-10), Point(x0+70, y0-30), Point(x0+90, y0-30), Point(x0+110, y0-10), :stroke)
	end
end 200 200

# ╔═╡ 5f48ed39-078a-4eec-839d-b750c0faf8d5
md"- Type hinting with Multiple Dispatch provides enough information for the compiler to generate efficient machine code.
1) Type hinting is a feature to tell compiler the types of parameter to a function call	
2) Multiple Dispatch is a feature to dynamically dispatch function based on type information of function parameters 
"

# ╔═╡ 83c84e7a-7a43-4db9-876d-c3edf9ec2ab8
methods(+)[1:10]

# ╔═╡ db3bb766-e707-45b3-a7a6-e9f0ef9a7e80
md"
## Icing on the cake
- Julia supports unicode 
"

# ╔═╡ fb854b24-6081-4a68-8ab1-82b7e95a2714
begin
	println("Ain't nobody likes to read lambda gamma pi, show me the unicode λ, γ, π.")
end

# ╔═╡ 6a3e89fe-2a59-4ba8-ba8f-40a7062f7baa
md"
# Installation and Setup
## Juliaup
- `Juliaup` is a tool to manage Julia versions and installations.
- It allows you to install multiple versions of Julia and switch between them easily.

### Installing Juliaup
- Enter the following commands in your terminal will install Juliaup.
**Linux and macOS**
```bash
curl -fsSL https://install.julialang.org | sh
```
**Windows**
```bash
winget install julia -s msstore
```
"

# ╔═╡ 60126082-d482-4549-affe-363bd8a24556
Markdown.MD(
    Markdown.Admonition(
        "tip",
        "Window Store:",
        [
            md"""
            You can also install Juliaup directly from [Windows Store](https://www.microsoft.com/store/apps/9NJNWW8PVKMN).
            """,
        ],
    ),
)

# ╔═╡ 4177977c-462a-49a6-afd7-5a83b7cb3c7e
Markdown.MD(
    Markdown.Admonition(
        "hint",
        "Alternative Juliaup Server",
        [
            md"""
            If you are in China, you may need to specify another server for installing Juliaup.

            **Linux and macOS**
            ```bash
            export JULIAUP_SERVER=https://mirrors.tuna.tsinghua.edu.cn/julia-releases
            ```
            **Windows**
            ```PowerShell
            $env:JULIAUP_SERVER="https://mirrors.tuna.tsinghua.edu.cn/julia-releases"
            ```
            """,
        ],
    ),
)

# ╔═╡ a5c07334-7ea0-4963-b3e7-088c39c44175
md"
## Installing Julia
- Once you have installed Juliaup, you can install Julia by running the following command in your terminal.
  ```bash
  juliaup default 1.9
  ```
- To verify that Julia is installed, run the following command in your terminal.
  ```bash
  julia
  ```
- It should start a Julia REPL(Read-Eval-Print-Loop) session like this
![REPL Session]()
- If you wish to install a specific version of Julia, please refer to the [documentation](https://github.com/JuliaLang/juliaup).

## Package Management
- `Julia` has a mature eco-system for scientific computing.
- 'Pkg' is the built-in package manager for Julia.
- To enter the package manager, press `]` in the REPL.
![PackageMangement](https://github.com/exAClior/QMBCTutorial/blob/ys/julia-tutorial/notebooks/resources/scripts/Packages.gif?raw=true)
- The environment is indicated by the `(@v1.9)`.
- To add a package, type `add <package name>`.

### First Package: PkgServerClient.jl
- Due to some special reasons, we need to install `PkgServerClient.jl` first.
- You should first execute the following command

  **Linux and macOS**
  ```bash
    export JULIA_PKG_SERVER='https://mirrors.nju.edu.cn/julia'
  ```

  **Windows**
  ```PowerShell
    $env:JULIA_PKG_SERVER='https://mirrors.nju.edu.cn/julia'
  ```
- Then you can add `PkgServerClient.jl` by typing `add PkgServerClient` in the package manager.
- To make sure Julia uses the package automatically at startup, configure the `startup.jl` file.

### More Packages
- You may find more packages for scientific computing [here](https://juliahub.com/).
![JuliaHub]()

### Unittesting
- Built-in unit testing
![Unittest](https://github.com/exAClior/QMBCTutorial/blob/ys/julia-tutorial/notebooks/resources/scripts/unittest.gif?raw=true)
"

# ╔═╡ aff93d69-e2ff-4d1e-b5c2-728c484d80fa
md"
## Editor
- TL;DR: use VSCode
![VSCode Julia Layout](https://code.visualstudio.com/assets/docs/languages/julia/overview.png)
"

# ╔═╡ 7ced479f-0d0e-4b94-834c-b3885ef077a6
md"
# Examples
## ED
- We are all expert in ED
- Important algorithm for benchmarking
- Demonstrate ED of a 1D Heisenberg XXZ model.
- Construct Hamiltonian using `Yao.jl`
"

# ╔═╡ 356cd762-e438-47c7-97b8-3f08b02048f3
md"
### Yao
- Yao is an Extensible, Efficient Quantum Algorithm Design library For Humans written and maintained by Xiuezhe (Roger) Luo and Jin-Guo Liu

![Roger Luo](./resources/imgs/roger.png)
![Jin-Guo Liu](./resources/imgs/jinguo.png)
![Yao.jl]()
- Construction of Hamiltonian as Sparse Matrices
"

# ╔═╡ 7f8975e7-9558-46c3-8348-0a53148a5c23
function make_XXZhamiltonian(L::Int, J::Real, h::Real; periodic::Bool=false)
    # construct the Hamiltonian
    # L: number of sites
    # J: coupling strength
    # h: magnetic field strength
    # return: Hamiltonian
    hamiltonian = sum(put(L,i=>Z) for i in 1:L)
    offset = periodic ? 0 : 1
    for pauli in [X,Y,Z]
    	hamiltonian += sum(kron(L, i=>pauli , mod1(i+1, L)=>pauli) for i in 1:L-offset)
    end

    return hamiltonian
end

# ╔═╡ 28b9449a-95d2-4864-8cbd-9eb99d5611b0
ham = make_XXZhamiltonian(10, 1.0, 0.0; periodic=true)


# ╔═╡ 981da071-b446-4b43-a1b1-9a809179e048
# I can fit 22 qubits, good!
mat(ham)

# ╔═╡ 5f6480e0-68ce-4a80-9970-dc6049ab8888
md"
#### Under the hood
- Pauli Matrices are constructed as sparse matrices
`(:Y, PermMatrix([2, 1], ConstGateDefaultType[-im, im]))`
[code](https://github.com/QuantumBFS/Yao.jl/blob/cfde9f072b56e830bc91fa27f51a121912eff130/lib/YaoBlocks/src/primitive/const_gate_gen.jl)
"

# ╔═╡ 2f554504-415d-4ad6-8b7c-e193221a3213
mat(Y)

# ╔═╡ 72a9962e-ecbe-4225-b5c5-7b5d2017ca7d
begin
	yy = mat(kron(2,Y,Y));
	println(yy.perm)
	println(yy.vals)
	xx = mat(kron(2,X,X));
end

# ╔═╡ 14fd1a93-6123-4a28-833c-5ca20c3efb79
begin
	xxpyy = sum([kron(2,X,X),kron(2,Y,Y)])
	mat(xxpyy)
end

# ╔═╡ f2e9efd9-76d3-461a-bf55-3a4916673dc1
md"
### Outside of Spin 1/2
Of course, there are ways to construct Hamiltonian constructed from other basis like Gell-Mann matrices
"

# ╔═╡ 3906d7ad-a934-4fc0-9f63-266006fc25d8
begin
@const_gate Gell1 = PermMatrix([2,1,3],ComplexF64[1,1,0]) nlevel=3 
@const_gate Gell2 = PermMatrix([2,1,3],ComplexF64[-im,im,0]) nlevel=3
@const_gate Gell3 = Diagonal(ComplexF64[1,-1,0]) nlevel=3
end

# ╔═╡ f87f65e8-770c-46b7-a416-df1cfa16f917
function make_spin1hamiltonian(L::Int, J::Real, h::Real; periodic::Bool=false)
    # construct the Hamiltonian
    # L: number of sites
    # J: coupling strength
    # h: magnetic field strength
    # return: Hamiltonian
    hamiltonian = sum(put(L,i=>Gell3) for i in 1:L)
    offset = periodic ? 0 : 1
    for gell in [Gell1,Gell2,Gell3]
    	hamiltonian += sum(kron(L, i=>gell , mod1(i+1, L)=>gell) for i in 1:L-offset)
    end

    return hamiltonian
end

# ╔═╡ 6d3c3d49-b7fb-4057-a6c6-6ac9a7090340
ham_spin1 = make_spin1hamiltonian(10,1,1;periodic=true)

# ╔═╡ 488642c1-ffc3-4e7c-98d0-84bac47967ea
mat(ham_spin1)

# ╔═╡ 026887ca-4ed2-4192-a730-8f0fcd934d07
md"
### Eigenvalue solving
"

# ╔═╡ 84ff2a7f-4484-4264-916c-4fe64601446e
# ╠═╡ disabled = true
#=╠═╡
eigsolve(mat(ham))
# let's dive into it
# we should use symmetry to simplify the process https://www.youtube.com/watch?v=CoY5XwmFkF4
# use MPSKit and etc
  ╠═╡ =#

# ╔═╡ a07a06f8-7ed3-4ec0-8a88-af07cccd4def
md"
## DMRG
"

# ╔═╡ 92861ca5-ce68-4874-8451-c81b54772826
md"
# Information
- Should you be interested in Julia, you can join the following communities to obtain more information
  1) [Slack](https://julialang.org/slack/)
  2) [Zulip](https://julialang.zulipchat.com/register/)
  3) [HKUST(GZ) Zulip](https://zulip.hkust-gz.edu.cn/)
  4) [Julia Discourse](https://discourse.julialang.org/)
  5) [JuliaCN Discourse](https://discourse.juliacn.com/)

- There are many opportunities for you to contribute to the Julia community
  1) [OSPP](https://summer-ospp.ac.cn/)
  2) [JSoC](https://julialang.org/jsoc/)
  3) [GSoC](https://julialang.org/jsoc/#google_summer_of_code_gsoc)
"

# ╔═╡ b98c561d-01d9-4ca5-82a4-2d87f19bb494
md"
#
References
- [Why is Julia faster than Python?](https://juejin.cn/post/6844903782413778952)
- [Why is Julia so fast](https://juejin.cn/post/6844903660669911054)
- [TUM Course on Machine Learning using Julia](https://github.com/adrhill/julia-ml-course)
- [Setting Up Julia PkgServer](https://discourse.juliacn.com/t/topic/2969)
- [Is Julia Static or Dynamic](https://stackoverflow.com/questions/28078089/is-julia-dynamically-typed)
- [Steven Johnson Lecture](https://www.youtube.com/watch?v=6JcMuFgnA6U)
"

# ╔═╡ Cell order:
# ╟─0aae83c1-d0e7-435e-8446-164a2bdc9696
# ╟─9f9230a7-6900-42b3-a3c6-df303c9d9f39
# ╟─0d49dbcd-b3d2-4965-b0b7-1de58f72025e
# ╟─b47de57f-ee37-4a92-b99d-1a3763c31a3f
# ╟─0a2a79cc-9a37-4f96-b422-1a529d6a689b
# ╟─3cd5a1aa-5229-43b1-8016-47903a1dae6f
# ╟─57684dc8-31f9-11ee-2888-770b687183aa
# ╠═1e84d230-2548-4da7-bc10-1ad2efcf14f4
# ╟─7a2729c6-261f-498c-a3f7-f6ed0a383e0f
# ╠═57cc9fed-b719-45e1-8a66-92779275b4ed
# ╠═697aee80-e7c9-4f27-9408-f44a2d835210
# ╠═f45f49c5-597f-4be5-9359-3971d6cbf40e
# ╠═36d487e3-f8a6-460d-98db-06e65b5dcd51
# ╠═5df12e78-bfb0-4806-9354-d17e277c4e63
# ╠═cd026a50-6e6c-4828-9880-548ea249451a
# ╠═0684f0b3-3030-4297-9d5b-026ff166ee1f
# ╠═e2633187-3b79-4c58-b2a3-8dc6d30b9b9c
# ╟─bec0efb6-1f14-4e22-b01c-bbf992f29b52
# ╟─cfaa7ee8-8de8-4933-8396-0350408a14b4
# ╟─69738959-95a3-46b4-9124-5db1160c1295
# ╟─5f48ed39-078a-4eec-839d-b750c0faf8d5
# ╠═83c84e7a-7a43-4db9-876d-c3edf9ec2ab8
# ╠═db3bb766-e707-45b3-a7a6-e9f0ef9a7e80
# ╠═fb854b24-6081-4a68-8ab1-82b7e95a2714
# ╠═6a3e89fe-2a59-4ba8-ba8f-40a7062f7baa
# ╟─60126082-d482-4549-affe-363bd8a24556
# ╟─4177977c-462a-49a6-afd7-5a83b7cb3c7e
# ╟─a5c07334-7ea0-4963-b3e7-088c39c44175
# ╟─aff93d69-e2ff-4d1e-b5c2-728c484d80fa
# ╠═7ced479f-0d0e-4b94-834c-b3885ef077a6
# ╟─dd4ea4a2-9e06-43f7-976b-0c9af661cc8e
# ╠═356cd762-e438-47c7-97b8-3f08b02048f3
# ╠═7f8975e7-9558-46c3-8348-0a53148a5c23
# ╠═28b9449a-95d2-4864-8cbd-9eb99d5611b0
# ╠═981da071-b446-4b43-a1b1-9a809179e048
# ╟─5f6480e0-68ce-4a80-9970-dc6049ab8888
# ╠═2f554504-415d-4ad6-8b7c-e193221a3213
# ╠═72a9962e-ecbe-4225-b5c5-7b5d2017ca7d
# ╠═14fd1a93-6123-4a28-833c-5ca20c3efb79
# ╠═f2e9efd9-76d3-461a-bf55-3a4916673dc1
# ╠═3906d7ad-a934-4fc0-9f63-266006fc25d8
# ╠═f87f65e8-770c-46b7-a416-df1cfa16f917
# ╠═6d3c3d49-b7fb-4057-a6c6-6ac9a7090340
# ╠═488642c1-ffc3-4e7c-98d0-84bac47967ea
# ╠═026887ca-4ed2-4192-a730-8f0fcd934d07
# ╠═84ff2a7f-4484-4264-916c-4fe64601446e
# ╠═a07a06f8-7ed3-4ec0-8a88-af07cccd4def
# ╟─92861ca5-ce68-4874-8451-c81b54772826
# ╟─b98c561d-01d9-4ca5-82a4-2d87f19bb494
