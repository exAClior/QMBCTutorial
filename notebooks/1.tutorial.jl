### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 0aae83c1-d0e7-435e-8446-164a2bdc9696
begin
	using Pkg
	Pkg.activate(".");
	#Pkg.build("PyCall");
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

# ╔═╡ 748bc89c-43ac-462b-910d-c4b9489008b3
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

# ╔═╡ 3d0e81de-5592-41aa-9926-a28e12ab5be4
begin 
	using ITensors
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
			Yusheng Zhao, Jinguo Liu
		</p>
		<p style="font-size: 20px;">
			MinJiang University, Fu Zhou, 08/17/2023
		</p>
	</div>
"""

# ╔═╡ e1a5a58b-733d-49d0-b851-e36310e09b37
md"""
# Promised: Road to mastering machine learning
This lecture is supposed to be delivered by Lei. He wanted to lecture about machine learning. If you are interesting in learning machine learning for physicists, please check the following repo and books.
## Machine learning for physicists
Github: [wangleiphy/ml4p](https://github.com/wangleiphy/ml4p)
"""

# ╔═╡ 580cb330-6ddf-4297-88f6-881a65247427
md"""![](https://user-images.githubusercontent.com/6257240/260753478-f4960c86-65f0-4d71-a264-1a7f47b0b3b7.png)
"""

# ╔═╡ 8d83e226-16ec-415f-9b12-b63974058ae8
md"## The book that I enjoyed reading"

# ╔═╡ f8cc0dca-2e41-4361-b750-281f1e223dde
html"""
<img src="https://user-images.githubusercontent.com/6257240/260753742-e1146b86-7876-4f80-93cd-7242aa518815.png" width=300>
"""

# ╔═╡ 619a5dc2-5d0d-405f-a7d6-fd0e8160b65a
md"## Online lecture: CS231n"

# ╔═╡ ebad386c-4630-4f6a-94eb-548b14cd9807
md"Youtube Video"

# ╔═╡ 61c24322-d7bc-4e0d-9868-ee5ad07399bb
html"""
<iframe width="560" height="315" src="https://www.youtube.com/embed/vT1JzLTH4G4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
"""

# ╔═╡ 3cd5a1aa-5229-43b1-8016-47903a1dae6f
md"""
# Motivation
## "What I cannot create, I do not understand" -R.P Feynman 
![Feynman Quote](https://qph.cf2.quoracdn.net/main-qimg-87833c78a604ff07a82ff7787574e197.webp)
## What language to use?
![A Few Criterions](https://pbs.twimg.com/media/F3IROZ6WsAA_74B?format=jpg&name=medium)
"""

# ╔═╡ d81aa3cb-c485-4005-8d94-2e3dd6845ef3
md"""
## Anders Sandvik's (Creater of Stochastic Series Expansion Monte Carlo method) Answer
- Anders Sandvik's [course page](https://physics.bu.edu/~py502/)
"""

# ╔═╡ 57684dc8-31f9-11ee-2888-770b687183aa
md"""
# Why Julia?
## Short Answer
* **Speed** 
* **Easy to use**
* **Reproducibility**

## What is Julia?
Julia is an **unconventional dynamic** programming language with the goal of being **easy to be made fast**.

- Shallow learning curve & high flexibility
- $(html"<s>Low performance</s>")
- $(html"<s>Two language problem</s>")
"""

# ╔═╡ 1e84d230-2548-4da7-bc10-1ad2efcf14f4
function sumtil(n)
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
	@btime py"sumtil"(200000);
	@btime sumtil(200000);
	@btime c_sumtil(200000);
end

# ╔═╡ bec0efb6-1f14-4e22-b01c-bbf992f29b52
md"
### Easy to be made fast
#### When is a program fast?
- Computers are fast when it knows EXACTLY what to do
- Box and Pointer Model
- Slowness of a *typical* Dynamic language is related to cache miss.
"

# ╔═╡ 69738959-95a3-46b4-9124-5db1160c1295
md"""
#### Julia is different!
- Julia has a well structured type system.
- JIT(Just in time) compilation with *Type Inference* 
"""

# ╔═╡ c7e05c5e-5519-4230-806f-1fc37a1ff9ef
@code_typed 1.0 + 2.0

# ╔═╡ f88c1e2a-13fd-4c29-8d2d-d55cea652944
@code_typed 1 + 2.0

# ╔═╡ 83c84e7a-7a43-4db9-876d-c3edf9ec2ab8
with_terminal() do
	@code_native 1.0 + 2.0
end

# ╔═╡ c41c8ca1-ddb9-491c-8250-faa766f6fce1
with_terminal() do
	@code_typed sumtil(2)
end

# ╔═╡ 0d451173-703c-4a6b-aae7-e6df6d41a0e1
run(`gcc -S lib/add.c`);

# ╔═╡ 50a44767-617f-4c57-92f1-96391dee77e6
with_terminal() do
	run(`cat lib/add.s`)
end

# ╔═╡ 6a3e89fe-2a59-4ba8-ba8f-40a7062f7baa
md"
# Installation and Setup
Installation Guide: [ CodingThrust/CodingClub](https://github.com/CodingThrust/CodingClub/blob/main/julia/1.julia-setup.md)
"

# ╔═╡ 9d050c0c-163e-4337-a470-41bd3b02e4cf
md"""
# How to program in Julia
## Grammars: [Tutorial](https://www.youtube.com/watch?v=uiQpwMQZBTA)
- Almost Python like, but
    - Index starts from 1
    - Column Major

## *Multiple Dispatch*
- Programming Paradigm
- Expressiveness
- Contrasted with Single Dispatch Polymorphism
"""

# ╔═╡ 34880c43-25d3-444b-9f83-297fe6d8ed2e


# ╔═╡ e0ae8990-8fb0-4908-b6b9-055ea76685e6
abstract type Pet end

# ╔═╡ f7285edd-8518-499a-8f2d-6a2b2009e0c1
struct Dog <: Pet
		name::String 
	end

# ╔═╡ 58d3d1d0-2567-4a6b-b934-1e2b2151cfdd
struct Cat <: Pet
		name::String 
	end

# ╔═╡ 7b17bef3-de70-4917-8d0c-44b712346ff4
meets(a::Pet, b::Pet) = "FALLBACK"

# ╔═╡ 7c31963c-1f39-4756-9b09-aeda6c8e7079
meets(a::Dog, b::Dog) = "sniffs"

# ╔═╡ c1bb914b-60dd-4248-a76e-40ea2f96b4ab
meets(a::Dog, b::Cat) = "chases"

# ╔═╡ bfa038ae-7916-4516-87e2-b5b0e416f10f
meets(a::Cat, b::Dog) = "hisses"

# ╔═╡ 99b6b4e4-33f7-4b37-bc9d-073096bc0e50
meets(a::Cat, b::Cat) = "slinks"

# ╔═╡ 8f182daf-2257-4948-9a68-1b415b2c3992
function encounter(a::Pet, b::Pet)
		verb = meets(a,b)
		println("$(a.name) meets $(b.name) and $(verb)")
	end

# ╔═╡ 8bb17242-8593-4a5d-a16d-edb4e0be165e
sam = Dog("Sam");

# ╔═╡ 5e55f52f-b2e1-4ef6-b8c3-3965e515dfe0
bob = Dog("Bob");

# ╔═╡ 2e1ae33e-3d35-49c2-83d0-5f0c735f8953
erwin = Cat("Erwin");

# ╔═╡ 5d2e1ebd-e91e-4815-8015-da8e3a529ed3
tom = Cat("Tom");

# ╔═╡ dda093a1-c67b-45a3-b689-c19267bc999e
encounter(sam, bob)

# ╔═╡ b0211527-b726-43a9-9106-72671737f4f2
encounter(sam, erwin)

# ╔═╡ 5c8ecd56-3a81-4a84-8ab0-a8d165677b46
encounter(erwin, bob)

# ╔═╡ 32f709aa-7f10-43a3-a9d3-da6d9d929f35
encounter(erwin, tom)

# ╔═╡ 2ec8c38d-8dd4-467e-a086-226cb24cbdad
run(`g++ lib/multidispatch.cpp -o pets`)

# ╔═╡ 6ebd4529-b5b6-4fd3-939f-49fdefa32800
with_terminal() do
	run(`cat lib/multidispatch.cpp`)
end

# ╔═╡ 793f5963-fd2c-42e3-bfcd-c02a09834863
run(`./pets`)

# ╔═╡ 0f0175f9-cd97-45dd-8b55-51e51c887d2f
md"
### Benefit of MD
- Easy to define `new types` where old operations apply
- Easy to implement `new operations` on old types
"

# ╔═╡ 8ce8464c-6c11-4f40-af13-67c47fa02f7f
struct Snake <: Pet
	name::String
end

# ╔═╡ 257dea65-07d2-474c-8ddc-de77d68429bd
begin
	Nagini = Snake("Nagini")
	encounter(Nagini, erwin)
end

# ╔═╡ 3cf23202-59da-4ab1-b601-e08bf3fb437c
function hears(a::Cat, b::Union{Dog,Snake})
	println("$(a.name) hears $(b.name) and has a piloerection")
end

# ╔═╡ 2fbed606-16e0-4bfa-a86b-e76a11b60256
hears(erwin,Nagini)

# ╔═╡ 8189b0a2-c251-4705-a8b0-ef069e5c8b88
md"# Demo"

# ╔═╡ 26f9460b-6ddb-4984-a8f4-20d9fe1da63b
begin
	struct Point{N, T<:Real}
		coo::NTuple{N, T}
	end
	Point(args::Real...) = Point((args...,))
end

# ╔═╡ f579931f-eefc-4542-9a59-8964c30549bc
function Base.:-(p1::Point{N, T}, p2::Point{N,T}) where {N,T}
	Point(p1.coo .- p2.coo)
end

# ╔═╡ 5b96435c-3edd-4230-9e77-79db8c8e2c8e
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

# ╔═╡ e7c6e74a-4fc6-49fe-adad-537341043abb
@btime sqrt(sum(abs2, (2.0, 3.0, 4.0, 5.5) .- (1.0, 3.0, 5.0, 3.0)))

# ╔═╡ 17804c1f-76e9-4c0c-8ea3-41cf0f3af1c2
p1 = Point(2.0, 3.0)

# ╔═╡ c6c9e9f4-d5a7-473a-9e2b-8ecaf59875c9
p2 = Point(3.0, 4.0)

# ╔═╡ 7610f980-000f-4649-81fb-4f0bc0cbe5b9
@btime p1 - p2

# ╔═╡ d41bf372-e384-44bb-ab90-5c54e720c8e9
p3 = Point(3.0, 4.0, 5.0)

# ╔═╡ 31a0d920-2e28-4208-b23b-9cc10d48998b
p4 = Point(3.0, 4.0, 6.0)

# ╔═╡ 37bb59dc-40fe-4003-961a-e484096a419f
p4 - p3

# ╔═╡ aac44713-2c3e-48db-841f-956c4ce1413c


# ╔═╡ 7ced479f-0d0e-4b94-834c-b3885ef077a6
md"""
# Ecosystem
## Exact Diagonalization
- We are all experts in ED
- Important algorithm for benchmarking
- Demonstrate ED of a 1D Heisenberg XXZ model: $$H = \sum_{<i,j>} J \sigma_i^x \sigma_j^x + J \sigma_i^y \sigma_j^y + J_z \sigma_i^z\sigma_j^z$$
- Construct Hamiltonian using `Yao.jl`
- More professionally [ExactDiagonalization.jl](https://github.com/Quantum-Many-Body/ExactDiagonalization.jl)
"""

# ╔═╡ 356cd762-e438-47c7-97b8-3f08b02048f3
html"""
<h3>Yao</h3>

<url>
<li>
<a href="https://github.com/QuantumBFS/Yao.jl">Yao</a> is an Extensible, Efficient Quantum Algorithm Design library For Humans written and maintained by Xiuzhe (Roger) Luo and Jin-Guo Liu
</li>
<li>
<a href="https://arxiv.org/abs/1912.10877">arXiv:1912.10877</a>
</li>
<li>
<img src="https://pbs.twimg.com/profile_images/1136498887961849856/i2-m_GLr_400x400.jpg" width=100/>
<img src="https://avatars.githubusercontent.com/u/6257240?v=4" width=100/>
</li>
<li>
Construction of Hamiltonian as Sparse Matrices
</li>
</ul>
"""

# ╔═╡ 7f8975e7-9558-46c3-8348-0a53148a5c23
function make_XXZhamiltonian(L::Int, J::Real, Jz::Real; periodic::Bool=false)
    # construct the Hamiltonian
    # L: number of sites
    # J: coupling strength between pauli X and Y
    # Jz: coupling strength between pauli Z
    # return: Hamiltonian
    offset = periodic ? 0 : 1
    hamiltonian = sum([Jz * kron(L, i=>Z, mod1(i+1,L)=>Z) for i in 1:L-offset])
    for pauli in [X,Y]
    	hamiltonian += sum([J * kron(L, i=>pauli , mod1(i+1, L)=>pauli) for i in 1:L-offset])
    end

    return hamiltonian
end

# ╔═╡ ce2a6c63-5fa3-4633-8d23-144f7d8d825e
md"""Number of sites: $(@bind nq Slider(10:22;default=10, show_value=true))"""

# ╔═╡ 28b9449a-95d2-4864-8cbd-9eb99d5611b0
ham = make_XXZhamiltonian(nq, 1.0, 1.0; periodic=false)

# ╔═╡ 981da071-b446-4b43-a1b1-9a809179e048
# I can fit 22 qubits, good!
mat(ham)

# ╔═╡ 5f6480e0-68ce-4a80-9970-dc6049ab8888
md"
#### Under the hood
- Pauli Matrices are constructed as sparse matrices
`(:Y, PermMatrix([2, 1], ConstGateDefaultType[-im, im]))`
[code](https://github.com/QuantumBFS/Yao.jl/blob/cfde9f072b56e830bc91fa27f51a121912eff130/lib/YaoBlocks/src/primitive/const_gate_gen.jl)
- Kronecker products and summations are supported on sparse matrices
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

# ╔═╡ 026887ca-4ed2-4192-a730-8f0fcd934d07
md"
### Eigenvalue solving
- We will use `KrylovKit.jl`
- It is a Julia package collecting a number of Krylov-based algorithms for linear problems, singular value and eigenvalue problems and the application of functions of linear maps or operators to vectors.
"

# ╔═╡ d1f39d72-702f-444c-9e9c-c6b8b0519707
md"""Show following doc: $(@bind show_te_doc1 CheckBox(default=false))"""

# ╔═╡ d92ca84d-e5a9-40be-bea2-63d4cfae608e
if show_te_doc1
	@doc eigsolve
end

# ╔═╡ 84ff2a7f-4484-4264-916c-4fe64601446e
eval_eds, vecs_ed, info_ed =  eigsolve(mat(ham), 3, :SR,ishermitian=true)

# ╔═╡ 9cb12308-4748-47ac-af03-6125e4bb01b5
md"""
### Time Evolution
API for doing real time evolution and imaginary time evolution
"""

# ╔═╡ b0407c15-0e28-4af0-8776-740d42dceb32
md"""Show following doc: $(@bind show_te_doc CheckBox(default=false))"""

# ╔═╡ 966ec890-a580-4350-9f7b-25ff25bd521a
if show_te_doc
	@doc time_evolve
end

# ╔═╡ f9213805-dce9-4903-8b7e-922b884bcf2a
md"""Do Imaginary time evolution: $(@bind do_eval CheckBox(default=false))"""

# ╔═╡ 81895e21-ba2a-40b8-a618-0de9cf1aaff8
begin
	if do_eval
		evo_op = time_evolve(ham,-im*0.01;tol=1e-10,check_hermicity=false)
		ψ = rand_state(nq)
		for _ in 1:300
			apply!(ψ,evo_op)
			ψ = Yao.normalize!(ψ)
		end
		e_it = real(Yao.expect(ham,ψ));
	end
end

# ╔═╡ c6633f9e-898f-4e7b-bc14-04d46a9ad563
if do_eval
Markdown.MD(
    Markdown.Admonition(
        "hint",
        "Answer Comparison",
        [
            md"""
            Relative error compare to Exact Diagonalization answer: $((e_it-eval_eds[1])/eval_eds[1])
            """,
        ],
    ),
)
end

# ╔═╡ a07a06f8-7ed3-4ec0-8a88-af07cccd4def
md"
## DMRG
- If you want to be a happy API caller, just use `ITensors.jl`
- `ITensors.jl` is a library for rapidly creating correct and efficient tensor network algorithms
### Hamiltonian
- We create Matrix Product Operator using ITensor interface
- The same XXZ Model as in ED section 
"

# ╔═╡ 863ab90d-cd39-412d-9973-fbf6615802f8
function make_xxzmpo(L::Int, J::Real, Jz::Real; periodic::Bool=false)
    sites = siteinds("S=1/2", L)
    ham = OpSum()
    offset = periodic ? 0 : 1
    for i in 1:L-offset
		ham += 4*J , "Sx",i,"Sx",mod1(i+1,L)
		ham += 4*J , "Sy",i,"Sy",mod1(i+1,L)
        ham += 4*Jz, "Sz", i, "Sz", mod1(i+1,L)
    end
    return MPO(ham, sites), sites
end

# ╔═╡ 1efcce00-9b0a-497b-8841-773ac30bed75
xxzmpo, xxzsites = make_xxzmpo(nq,1.0,1.0;periodic=false)

# ╔═╡ 25528a3b-21d8-412f-b4b3-7fe216fa61c7
function do_dmrg(H,sites,psi0_i,sweeps::Int, maxdims::Vector{Int},cutoff::Float64)
    # Do 10 sweeps of DMRG, gradually
    # increasing the maximum MPS
    # bond dimension
    sweeps = Sweeps(sweeps)
    setmaxdim!(sweeps,maxdims...)
    setcutoff!(sweeps,cutoff) # Run the DMRG algorithm
    energy,psi0 = dmrg(H,psi0_i,sweeps)
end

# ╔═╡ f28b5a97-7ab2-45d7-90e0-2e56f040420a
begin
	psi0 = randomMPS(xxzsites;linkdims=10)
	energy, ψ₀ = do_dmrg(xxzmpo,xxzsites,psi0,10,[10,20,50,60,80,100,120,140,160,180,200],1e-11)
end

# ╔═╡ 50394dbd-a65f-4b25-9d57-1debacc16fba
Markdown.MD(
    Markdown.Admonition(
        "hint",
        "Answer Comparison",
        [
            md"""
            Relative error compare to Exact Diagonalization answer: $((energy-eval_eds[1])/eval_eds[1])
            """,
        ],
    ),
)

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

# ╔═╡ 0fd67679-c034-46d8-ac88-51b2eb6b6d91
md"""
# Acknowledgements
We appreciate the help of Jin-Guo Liu, Gui-Xin Liu, Shi-Gang Ou, Rui-Si Wang, and Zhongyi Ni during the preparation of this presentation.
"""

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
- [The ITensor Software Library for Tensor Network Calculations](https://arxiv.org/abs/2007.14822)
"

# ╔═╡ 5d9ebbeb-6c69-470e-a832-83c1b46c10e1
# ╠═╡ disabled = true
#=╠═╡
md"""
# My sleves
## Why not Python with Numba, Cython or PyPy?
- Numba specializes on numerical computation, what if you want to operate on strings?
- synergy between packages not well i.e numba and pandas
- [Stefan's take on Python vs Julia](https://discourse.julialang.org/t/julia-motivation-why-werent-numpy-scipy-numba-good-enough/2236/10)
"""
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═0aae83c1-d0e7-435e-8446-164a2bdc9696
# ╟─9f9230a7-6900-42b3-a3c6-df303c9d9f39
# ╟─0d49dbcd-b3d2-4965-b0b7-1de58f72025e
# ╟─b47de57f-ee37-4a92-b99d-1a3763c31a3f
# ╟─0a2a79cc-9a37-4f96-b422-1a529d6a689b
# ╟─e1a5a58b-733d-49d0-b851-e36310e09b37
# ╟─580cb330-6ddf-4297-88f6-881a65247427
# ╟─8d83e226-16ec-415f-9b12-b63974058ae8
# ╟─f8cc0dca-2e41-4361-b750-281f1e223dde
# ╟─619a5dc2-5d0d-405f-a7d6-fd0e8160b65a
# ╟─ebad386c-4630-4f6a-94eb-548b14cd9807
# ╟─61c24322-d7bc-4e0d-9868-ee5ad07399bb
# ╟─3cd5a1aa-5229-43b1-8016-47903a1dae6f
# ╟─d81aa3cb-c485-4005-8d94-2e3dd6845ef3
# ╟─57684dc8-31f9-11ee-2888-770b687183aa
# ╠═1e84d230-2548-4da7-bc10-1ad2efcf14f4
# ╟─7a2729c6-261f-498c-a3f7-f6ed0a383e0f
# ╠═57cc9fed-b719-45e1-8a66-92779275b4ed
# ╠═697aee80-e7c9-4f27-9408-f44a2d835210
# ╠═f45f49c5-597f-4be5-9359-3971d6cbf40e
# ╠═36d487e3-f8a6-460d-98db-06e65b5dcd51
# ╠═748bc89c-43ac-462b-910d-c4b9489008b3
# ╠═5df12e78-bfb0-4806-9354-d17e277c4e63
# ╟─bec0efb6-1f14-4e22-b01c-bbf992f29b52
# ╟─5b96435c-3edd-4230-9e77-79db8c8e2c8e
# ╟─cfaa7ee8-8de8-4933-8396-0350408a14b4
# ╟─69738959-95a3-46b4-9124-5db1160c1295
# ╠═c7e05c5e-5519-4230-806f-1fc37a1ff9ef
# ╠═f88c1e2a-13fd-4c29-8d2d-d55cea652944
# ╠═83c84e7a-7a43-4db9-876d-c3edf9ec2ab8
# ╠═c41c8ca1-ddb9-491c-8250-faa766f6fce1
# ╠═0d451173-703c-4a6b-aae7-e6df6d41a0e1
# ╠═50a44767-617f-4c57-92f1-96391dee77e6
# ╟─6a3e89fe-2a59-4ba8-ba8f-40a7062f7baa
# ╟─9d050c0c-163e-4337-a470-41bd3b02e4cf
# ╠═34880c43-25d3-444b-9f83-297fe6d8ed2e
# ╠═e0ae8990-8fb0-4908-b6b9-055ea76685e6
# ╠═f7285edd-8518-499a-8f2d-6a2b2009e0c1
# ╠═58d3d1d0-2567-4a6b-b934-1e2b2151cfdd
# ╠═8f182daf-2257-4948-9a68-1b415b2c3992
# ╠═7b17bef3-de70-4917-8d0c-44b712346ff4
# ╠═7c31963c-1f39-4756-9b09-aeda6c8e7079
# ╠═c1bb914b-60dd-4248-a76e-40ea2f96b4ab
# ╠═bfa038ae-7916-4516-87e2-b5b0e416f10f
# ╠═99b6b4e4-33f7-4b37-bc9d-073096bc0e50
# ╠═8bb17242-8593-4a5d-a16d-edb4e0be165e
# ╠═5e55f52f-b2e1-4ef6-b8c3-3965e515dfe0
# ╠═2e1ae33e-3d35-49c2-83d0-5f0c735f8953
# ╠═5d2e1ebd-e91e-4815-8015-da8e3a529ed3
# ╠═dda093a1-c67b-45a3-b689-c19267bc999e
# ╠═b0211527-b726-43a9-9106-72671737f4f2
# ╠═5c8ecd56-3a81-4a84-8ab0-a8d165677b46
# ╠═32f709aa-7f10-43a3-a9d3-da6d9d929f35
# ╠═2ec8c38d-8dd4-467e-a086-226cb24cbdad
# ╠═6ebd4529-b5b6-4fd3-939f-49fdefa32800
# ╠═793f5963-fd2c-42e3-bfcd-c02a09834863
# ╟─0f0175f9-cd97-45dd-8b55-51e51c887d2f
# ╠═8ce8464c-6c11-4f40-af13-67c47fa02f7f
# ╠═257dea65-07d2-474c-8ddc-de77d68429bd
# ╠═3cf23202-59da-4ab1-b601-e08bf3fb437c
# ╠═2fbed606-16e0-4bfa-a86b-e76a11b60256
# ╠═e7c6e74a-4fc6-49fe-adad-537341043abb
# ╟─8189b0a2-c251-4705-a8b0-ef069e5c8b88
# ╠═26f9460b-6ddb-4984-a8f4-20d9fe1da63b
# ╠═f579931f-eefc-4542-9a59-8964c30549bc
# ╠═17804c1f-76e9-4c0c-8ea3-41cf0f3af1c2
# ╠═c6c9e9f4-d5a7-473a-9e2b-8ecaf59875c9
# ╠═7610f980-000f-4649-81fb-4f0bc0cbe5b9
# ╠═d41bf372-e384-44bb-ab90-5c54e720c8e9
# ╠═31a0d920-2e28-4208-b23b-9cc10d48998b
# ╠═37bb59dc-40fe-4003-961a-e484096a419f
# ╠═aac44713-2c3e-48db-841f-956c4ce1413c
# ╟─7ced479f-0d0e-4b94-834c-b3885ef077a6
# ╟─dd4ea4a2-9e06-43f7-976b-0c9af661cc8e
# ╟─356cd762-e438-47c7-97b8-3f08b02048f3
# ╠═7f8975e7-9558-46c3-8348-0a53148a5c23
# ╟─ce2a6c63-5fa3-4633-8d23-144f7d8d825e
# ╠═28b9449a-95d2-4864-8cbd-9eb99d5611b0
# ╠═981da071-b446-4b43-a1b1-9a809179e048
# ╟─5f6480e0-68ce-4a80-9970-dc6049ab8888
# ╠═2f554504-415d-4ad6-8b7c-e193221a3213
# ╠═72a9962e-ecbe-4225-b5c5-7b5d2017ca7d
# ╠═14fd1a93-6123-4a28-833c-5ca20c3efb79
# ╟─026887ca-4ed2-4192-a730-8f0fcd934d07
# ╟─d1f39d72-702f-444c-9e9c-c6b8b0519707
# ╠═d92ca84d-e5a9-40be-bea2-63d4cfae608e
# ╠═84ff2a7f-4484-4264-916c-4fe64601446e
# ╟─9cb12308-4748-47ac-af03-6125e4bb01b5
# ╟─b0407c15-0e28-4af0-8776-740d42dceb32
# ╠═966ec890-a580-4350-9f7b-25ff25bd521a
# ╟─f9213805-dce9-4903-8b7e-922b884bcf2a
# ╠═81895e21-ba2a-40b8-a618-0de9cf1aaff8
# ╟─c6633f9e-898f-4e7b-bc14-04d46a9ad563
# ╟─a07a06f8-7ed3-4ec0-8a88-af07cccd4def
# ╠═3d0e81de-5592-41aa-9926-a28e12ab5be4
# ╠═863ab90d-cd39-412d-9973-fbf6615802f8
# ╠═1efcce00-9b0a-497b-8841-773ac30bed75
# ╠═25528a3b-21d8-412f-b4b3-7fe216fa61c7
# ╠═f28b5a97-7ab2-45d7-90e0-2e56f040420a
# ╟─50394dbd-a65f-4b25-9d57-1debacc16fba
# ╟─92861ca5-ce68-4874-8451-c81b54772826
# ╟─0fd67679-c034-46d8-ac88-51b2eb6b6d91
# ╟─b98c561d-01d9-4ca5-82a4-2d87f19bb494
# ╟─5d9ebbeb-6c69-470e-a832-83c1b46c10e1
