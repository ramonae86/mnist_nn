       £K"	  јqУ„Abrain.Event:2Ч3хlд      ±…lM	U|—qУ„A"я»
p
PlaceholderPlaceholder*
dtype0*(
_output_shapes
:€€€€€€€€€Р*
shape:€€€€€€€€€Р
R
Placeholder_1Placeholder*
dtype0*
_output_shapes
:*
shape:
d
random_normal/shapeConst*
valueB"     *
dtype0*
_output_shapes
:
W
random_normal/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
Y
random_normal/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
†
"random_normal/RandomStandardNormalRandomStandardNormalrandom_normal/shape*
T0*
dtype0* 
_output_shapes
:
РА*
seed2 *

seed 
}
random_normal/mulMul"random_normal/RandomStandardNormalrandom_normal/stddev*
T0* 
_output_shapes
:
РА
f
random_normalAddrandom_normal/mulrandom_normal/mean*
T0* 
_output_shapes
:
РА
В

l1_weights
VariableV2*
dtype0* 
_output_shapes
:
РА*
	container *
shape:
РА*
shared_name 
©
l1_weights/AssignAssign
l1_weightsrandom_normal*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights
q
l1_weights/readIdentity
l1_weights*
T0*
_class
loc:@l1_weights* 
_output_shapes
:
РА
`
random_normal_1/shapeConst*
valueB:А*
dtype0*
_output_shapes
:
Y
random_normal_1/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_1/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Я
$random_normal_1/RandomStandardNormalRandomStandardNormalrandom_normal_1/shape*
dtype0*
_output_shapes	
:А*
seed2 *

seed *
T0
~
random_normal_1/mulMul$random_normal_1/RandomStandardNormalrandom_normal_1/stddev*
T0*
_output_shapes	
:А
g
random_normal_1Addrandom_normal_1/mulrandom_normal_1/mean*
T0*
_output_shapes	
:А
u
l1_bias
VariableV2*
dtype0*
_output_shapes	
:А*
	container *
shape:А*
shared_name 
Э
l1_bias/AssignAssignl1_biasrandom_normal_1*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А
c
l1_bias/readIdentityl1_bias*
_output_shapes	
:А*
T0*
_class
loc:@l1_bias
f
random_normal_2/shapeConst*
valueB"   А   *
dtype0*
_output_shapes
:
Y
random_normal_2/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_2/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
§
$random_normal_2/RandomStandardNormalRandomStandardNormalrandom_normal_2/shape*
T0*
dtype0* 
_output_shapes
:
АА*
seed2 *

seed 
Г
random_normal_2/mulMul$random_normal_2/RandomStandardNormalrandom_normal_2/stddev*
T0* 
_output_shapes
:
АА
l
random_normal_2Addrandom_normal_2/mulrandom_normal_2/mean*
T0* 
_output_shapes
:
АА
В

l2_weights
VariableV2*
dtype0* 
_output_shapes
:
АА*
	container *
shape:
АА*
shared_name 
Ђ
l2_weights/AssignAssign
l2_weightsrandom_normal_2*
validate_shape(* 
_output_shapes
:
АА*
use_locking(*
T0*
_class
loc:@l2_weights
q
l2_weights/readIdentity
l2_weights* 
_output_shapes
:
АА*
T0*
_class
loc:@l2_weights
`
random_normal_3/shapeConst*
valueB:А*
dtype0*
_output_shapes
:
Y
random_normal_3/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_3/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Я
$random_normal_3/RandomStandardNormalRandomStandardNormalrandom_normal_3/shape*
dtype0*
_output_shapes	
:А*
seed2 *

seed *
T0
~
random_normal_3/mulMul$random_normal_3/RandomStandardNormalrandom_normal_3/stddev*
T0*
_output_shapes	
:А
g
random_normal_3Addrandom_normal_3/mulrandom_normal_3/mean*
T0*
_output_shapes	
:А
u
l2_bias
VariableV2*
shape:А*
shared_name *
dtype0*
_output_shapes	
:А*
	container 
Э
l2_bias/AssignAssignl2_biasrandom_normal_3*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l2_bias
c
l2_bias/readIdentityl2_bias*
T0*
_class
loc:@l2_bias*
_output_shapes	
:А
f
random_normal_4/shapeConst*
valueB"А       *
dtype0*
_output_shapes
:
Y
random_normal_4/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_4/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
£
$random_normal_4/RandomStandardNormalRandomStandardNormalrandom_normal_4/shape*

seed *
T0*
dtype0*
_output_shapes
:	А *
seed2 
В
random_normal_4/mulMul$random_normal_4/RandomStandardNormalrandom_normal_4/stddev*
T0*
_output_shapes
:	А 
k
random_normal_4Addrandom_normal_4/mulrandom_normal_4/mean*
T0*
_output_shapes
:	А 
А

l3_weights
VariableV2*
dtype0*
_output_shapes
:	А *
	container *
shape:	А *
shared_name 
™
l3_weights/AssignAssign
l3_weightsrandom_normal_4*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
p
l3_weights/readIdentity
l3_weights*
T0*
_class
loc:@l3_weights*
_output_shapes
:	А 
_
random_normal_5/shapeConst*
valueB: *
dtype0*
_output_shapes
:
Y
random_normal_5/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_5/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Ю
$random_normal_5/RandomStandardNormalRandomStandardNormalrandom_normal_5/shape*

seed *
T0*
dtype0*
_output_shapes
: *
seed2 
}
random_normal_5/mulMul$random_normal_5/RandomStandardNormalrandom_normal_5/stddev*
T0*
_output_shapes
: 
f
random_normal_5Addrandom_normal_5/mulrandom_normal_5/mean*
T0*
_output_shapes
: 
s
l3_bias
VariableV2*
dtype0*
_output_shapes
: *
	container *
shape: *
shared_name 
Ь
l3_bias/AssignAssignl3_biasrandom_normal_5*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
b
l3_bias/readIdentityl3_bias*
_output_shapes
: *
T0*
_class
loc:@l3_bias
f
random_normal_6/shapeConst*
valueB"    
   *
dtype0*
_output_shapes
:
Y
random_normal_6/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_6/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Ґ
$random_normal_6/RandomStandardNormalRandomStandardNormalrandom_normal_6/shape*
dtype0*
_output_shapes

: 
*
seed2 *

seed *
T0
Б
random_normal_6/mulMul$random_normal_6/RandomStandardNormalrandom_normal_6/stddev*
T0*
_output_shapes

: 

j
random_normal_6Addrandom_normal_6/mulrandom_normal_6/mean*
T0*
_output_shapes

: 


out_weights
VariableV2*
shape
: 
*
shared_name *
dtype0*
_output_shapes

: 
*
	container 
ђ
out_weights/AssignAssignout_weightsrandom_normal_6*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

r
out_weights/readIdentityout_weights*
_output_shapes

: 
*
T0*
_class
loc:@out_weights
_
random_normal_7/shapeConst*
valueB:
*
dtype0*
_output_shapes
:
Y
random_normal_7/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_7/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
Ю
$random_normal_7/RandomStandardNormalRandomStandardNormalrandom_normal_7/shape*

seed *
T0*
dtype0*
_output_shapes
:
*
seed2 
}
random_normal_7/mulMul$random_normal_7/RandomStandardNormalrandom_normal_7/stddev*
T0*
_output_shapes
:

f
random_normal_7Addrandom_normal_7/mulrandom_normal_7/mean*
T0*
_output_shapes
:

t
out_bias
VariableV2*
dtype0*
_output_shapes
:
*
	container *
shape:
*
shared_name 
Я
out_bias/AssignAssignout_biasrandom_normal_7*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:
*
use_locking(
e
out_bias/readIdentityout_bias*
T0*
_class
loc:@out_bias*
_output_shapes
:

З
MatMulMatMulPlaceholderl1_weights/read*(
_output_shapes
:€€€€€€€€€А*
transpose_a( *
transpose_b( *
T0
S
AddAddMatMull1_bias/read*
T0*(
_output_shapes
:€€€€€€€€€А
J
SigmoidSigmoidAdd*
T0*(
_output_shapes
:€€€€€€€€€А
Е
MatMul_1MatMulSigmoidl2_weights/read*(
_output_shapes
:€€€€€€€€€А*
transpose_a( *
transpose_b( *
T0
W
Add_1AddMatMul_1l2_bias/read*
T0*(
_output_shapes
:€€€€€€€€€А
N
	Sigmoid_1SigmoidAdd_1*
T0*(
_output_shapes
:€€€€€€€€€А
Ж
MatMul_2MatMul	Sigmoid_1l3_weights/read*'
_output_shapes
:€€€€€€€€€ *
transpose_a( *
transpose_b( *
T0
V
Add_2AddMatMul_2l3_bias/read*
T0*'
_output_shapes
:€€€€€€€€€ 
M
	Sigmoid_2SigmoidAdd_2*
T0*'
_output_shapes
:€€€€€€€€€ 
З
MatMul_3MatMul	Sigmoid_2out_weights/read*'
_output_shapes
:€€€€€€€€€
*
transpose_a( *
transpose_b( *
T0
W
Add_3AddMatMul_3out_bias/read*'
_output_shapes
:€€€€€€€€€
*
T0
h
&softmax_cross_entropy_with_logits/RankConst*
dtype0*
_output_shapes
: *
value	B :
l
'softmax_cross_entropy_with_logits/ShapeShapeAdd_3*
T0*
out_type0*
_output_shapes
:
j
(softmax_cross_entropy_with_logits/Rank_1Const*
value	B :*
dtype0*
_output_shapes
: 
n
)softmax_cross_entropy_with_logits/Shape_1ShapeAdd_3*
T0*
out_type0*
_output_shapes
:
i
'softmax_cross_entropy_with_logits/Sub/yConst*
dtype0*
_output_shapes
: *
value	B :
†
%softmax_cross_entropy_with_logits/SubSub(softmax_cross_entropy_with_logits/Rank_1'softmax_cross_entropy_with_logits/Sub/y*
T0*
_output_shapes
: 
Ц
-softmax_cross_entropy_with_logits/Slice/beginPack%softmax_cross_entropy_with_logits/Sub*
N*
_output_shapes
:*
T0*

axis 
v
,softmax_cross_entropy_with_logits/Slice/sizeConst*
dtype0*
_output_shapes
:*
valueB:
к
'softmax_cross_entropy_with_logits/SliceSlice)softmax_cross_entropy_with_logits/Shape_1-softmax_cross_entropy_with_logits/Slice/begin,softmax_cross_entropy_with_logits/Slice/size*
_output_shapes
:*
Index0*
T0
Д
1softmax_cross_entropy_with_logits/concat/values_0Const*
dtype0*
_output_shapes
:*
valueB:
€€€€€€€€€
o
-softmax_cross_entropy_with_logits/concat/axisConst*
value	B : *
dtype0*
_output_shapes
: 
щ
(softmax_cross_entropy_with_logits/concatConcatV21softmax_cross_entropy_with_logits/concat/values_0'softmax_cross_entropy_with_logits/Slice-softmax_cross_entropy_with_logits/concat/axis*
T0*
N*
_output_shapes
:*

Tidx0
Ѓ
)softmax_cross_entropy_with_logits/ReshapeReshapeAdd_3(softmax_cross_entropy_with_logits/concat*
T0*
Tshape0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
`
(softmax_cross_entropy_with_logits/Rank_2RankPlaceholder_1*
T0*
_output_shapes
: 

)softmax_cross_entropy_with_logits/Shape_2ShapePlaceholder_1*
T0*
out_type0*#
_output_shapes
:€€€€€€€€€
k
)softmax_cross_entropy_with_logits/Sub_1/yConst*
value	B :*
dtype0*
_output_shapes
: 
§
'softmax_cross_entropy_with_logits/Sub_1Sub(softmax_cross_entropy_with_logits/Rank_2)softmax_cross_entropy_with_logits/Sub_1/y*
T0*
_output_shapes
: 
Ъ
/softmax_cross_entropy_with_logits/Slice_1/beginPack'softmax_cross_entropy_with_logits/Sub_1*
T0*

axis *
N*
_output_shapes
:
x
.softmax_cross_entropy_with_logits/Slice_1/sizeConst*
dtype0*
_output_shapes
:*
valueB:
р
)softmax_cross_entropy_with_logits/Slice_1Slice)softmax_cross_entropy_with_logits/Shape_2/softmax_cross_entropy_with_logits/Slice_1/begin.softmax_cross_entropy_with_logits/Slice_1/size*
Index0*
T0*
_output_shapes
:
Ж
3softmax_cross_entropy_with_logits/concat_1/values_0Const*
dtype0*
_output_shapes
:*
valueB:
€€€€€€€€€
q
/softmax_cross_entropy_with_logits/concat_1/axisConst*
value	B : *
dtype0*
_output_shapes
: 
Б
*softmax_cross_entropy_with_logits/concat_1ConcatV23softmax_cross_entropy_with_logits/concat_1/values_0)softmax_cross_entropy_with_logits/Slice_1/softmax_cross_entropy_with_logits/concat_1/axis*

Tidx0*
T0*
N*
_output_shapes
:
Ї
+softmax_cross_entropy_with_logits/Reshape_1ReshapePlaceholder_1*softmax_cross_entropy_with_logits/concat_1*
T0*
Tshape0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
д
!softmax_cross_entropy_with_logitsSoftmaxCrossEntropyWithLogits)softmax_cross_entropy_with_logits/Reshape+softmax_cross_entropy_with_logits/Reshape_1*
T0*?
_output_shapes-
+:€€€€€€€€€:€€€€€€€€€€€€€€€€€€
k
)softmax_cross_entropy_with_logits/Sub_2/yConst*
value	B :*
dtype0*
_output_shapes
: 
Ґ
'softmax_cross_entropy_with_logits/Sub_2Sub&softmax_cross_entropy_with_logits/Rank)softmax_cross_entropy_with_logits/Sub_2/y*
_output_shapes
: *
T0
y
/softmax_cross_entropy_with_logits/Slice_2/beginConst*
dtype0*
_output_shapes
:*
valueB: 
Щ
.softmax_cross_entropy_with_logits/Slice_2/sizePack'softmax_cross_entropy_with_logits/Sub_2*
T0*

axis *
N*
_output_shapes
:
о
)softmax_cross_entropy_with_logits/Slice_2Slice'softmax_cross_entropy_with_logits/Shape/softmax_cross_entropy_with_logits/Slice_2/begin.softmax_cross_entropy_with_logits/Slice_2/size*
Index0*
T0*
_output_shapes
:
ј
+softmax_cross_entropy_with_logits/Reshape_2Reshape!softmax_cross_entropy_with_logits)softmax_cross_entropy_with_logits/Slice_2*
T0*
Tshape0*#
_output_shapes
:€€€€€€€€€
O
ConstConst*
dtype0*
_output_shapes
:*
valueB: 
~
MeanMean+softmax_cross_entropy_with_logits/Reshape_2Const*
_output_shapes
: *
	keep_dims( *

Tidx0*
T0
R
gradients/ShapeConst*
valueB *
dtype0*
_output_shapes
: 
X
gradients/grad_ys_0Const*
dtype0*
_output_shapes
: *
valueB
 *  А?
o
gradients/FillFillgradients/Shapegradients/grad_ys_0*
T0*

index_type0*
_output_shapes
: 
k
!gradients/Mean_grad/Reshape/shapeConst*
valueB:*
dtype0*
_output_shapes
:
М
gradients/Mean_grad/ReshapeReshapegradients/Fill!gradients/Mean_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
:
Д
gradients/Mean_grad/ShapeShape+softmax_cross_entropy_with_logits/Reshape_2*
T0*
out_type0*
_output_shapes
:
Ш
gradients/Mean_grad/TileTilegradients/Mean_grad/Reshapegradients/Mean_grad/Shape*
T0*#
_output_shapes
:€€€€€€€€€*

Tmultiples0
Ж
gradients/Mean_grad/Shape_1Shape+softmax_cross_entropy_with_logits/Reshape_2*
T0*
out_type0*
_output_shapes
:
^
gradients/Mean_grad/Shape_2Const*
dtype0*
_output_shapes
: *
valueB 
c
gradients/Mean_grad/ConstConst*
valueB: *
dtype0*
_output_shapes
:
Ц
gradients/Mean_grad/ProdProdgradients/Mean_grad/Shape_1gradients/Mean_grad/Const*
	keep_dims( *

Tidx0*
T0*
_output_shapes
: 
e
gradients/Mean_grad/Const_1Const*
valueB: *
dtype0*
_output_shapes
:
Ъ
gradients/Mean_grad/Prod_1Prodgradients/Mean_grad/Shape_2gradients/Mean_grad/Const_1*
	keep_dims( *

Tidx0*
T0*
_output_shapes
: 
_
gradients/Mean_grad/Maximum/yConst*
value	B :*
dtype0*
_output_shapes
: 
В
gradients/Mean_grad/MaximumMaximumgradients/Mean_grad/Prod_1gradients/Mean_grad/Maximum/y*
_output_shapes
: *
T0
А
gradients/Mean_grad/floordivFloorDivgradients/Mean_grad/Prodgradients/Mean_grad/Maximum*
T0*
_output_shapes
: 
~
gradients/Mean_grad/CastCastgradients/Mean_grad/floordiv*

SrcT0*
Truncate( *
_output_shapes
: *

DstT0
И
gradients/Mean_grad/truedivRealDivgradients/Mean_grad/Tilegradients/Mean_grad/Cast*
T0*#
_output_shapes
:€€€€€€€€€
°
@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ShapeShape!softmax_cross_entropy_with_logits*
T0*
out_type0*
_output_shapes
:
и
Bgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeReshapegradients/Mean_grad/truediv@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Shape*
T0*
Tshape0*#
_output_shapes
:€€€€€€€€€
Б
gradients/zeros_like	ZerosLike#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
К
?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dimConst*
dtype0*
_output_shapes
: *
valueB :
€€€€€€€€€
М
;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Reshape?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dim*'
_output_shapes
:€€€€€€€€€*

Tdim0*
T0
Ў
4gradients/softmax_cross_entropy_with_logits_grad/mulMul;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
ѓ
;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax
LogSoftmax)softmax_cross_entropy_with_logits/Reshape*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
≥
4gradients/softmax_cross_entropy_with_logits_grad/NegNeg;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax*0
_output_shapes
:€€€€€€€€€€€€€€€€€€*
T0
М
Agradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dimConst*
valueB :
€€€€€€€€€*
dtype0*
_output_shapes
: 
Р
=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeAgradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dim*

Tdim0*
T0*'
_output_shapes
:€€€€€€€€€
н
6gradients/softmax_cross_entropy_with_logits_grad/mul_1Mul=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_14gradients/softmax_cross_entropy_with_logits_grad/Neg*0
_output_shapes
:€€€€€€€€€€€€€€€€€€*
T0
є
Agradients/softmax_cross_entropy_with_logits_grad/tuple/group_depsNoOp5^gradients/softmax_cross_entropy_with_logits_grad/mul7^gradients/softmax_cross_entropy_with_logits_grad/mul_1
”
Igradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependencyIdentity4gradients/softmax_cross_entropy_with_logits_grad/mulB^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*0
_output_shapes
:€€€€€€€€€€€€€€€€€€*
T0*G
_class=
;9loc:@gradients/softmax_cross_entropy_with_logits_grad/mul
ў
Kgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency_1Identity6gradients/softmax_cross_entropy_with_logits_grad/mul_1B^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*I
_class?
=;loc:@gradients/softmax_cross_entropy_with_logits_grad/mul_1*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
Г
>gradients/softmax_cross_entropy_with_logits/Reshape_grad/ShapeShapeAdd_3*
T0*
out_type0*
_output_shapes
:
Ц
@gradients/softmax_cross_entropy_with_logits/Reshape_grad/ReshapeReshapeIgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency>gradients/softmax_cross_entropy_with_logits/Reshape_grad/Shape*
T0*
Tshape0*'
_output_shapes
:€€€€€€€€€

b
gradients/Add_3_grad/ShapeShapeMatMul_3*
T0*
out_type0*
_output_shapes
:
f
gradients/Add_3_grad/Shape_1Const*
valueB:
*
dtype0*
_output_shapes
:
Ї
*gradients/Add_3_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_3_grad/Shapegradients/Add_3_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
Ќ
gradients/Add_3_grad/SumSum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape*gradients/Add_3_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Э
gradients/Add_3_grad/ReshapeReshapegradients/Add_3_grad/Sumgradients/Add_3_grad/Shape*
T0*
Tshape0*'
_output_shapes
:€€€€€€€€€

—
gradients/Add_3_grad/Sum_1Sum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape,gradients/Add_3_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Ц
gradients/Add_3_grad/Reshape_1Reshapegradients/Add_3_grad/Sum_1gradients/Add_3_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:

m
%gradients/Add_3_grad/tuple/group_depsNoOp^gradients/Add_3_grad/Reshape^gradients/Add_3_grad/Reshape_1
в
-gradients/Add_3_grad/tuple/control_dependencyIdentitygradients/Add_3_grad/Reshape&^gradients/Add_3_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_3_grad/Reshape*'
_output_shapes
:€€€€€€€€€

џ
/gradients/Add_3_grad/tuple/control_dependency_1Identitygradients/Add_3_grad/Reshape_1&^gradients/Add_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_3_grad/Reshape_1*
_output_shapes
:

Ѕ
gradients/MatMul_3_grad/MatMulMatMul-gradients/Add_3_grad/tuple/control_dependencyout_weights/read*
T0*'
_output_shapes
:€€€€€€€€€ *
transpose_a( *
transpose_b(
≥
 gradients/MatMul_3_grad/MatMul_1MatMul	Sigmoid_2-gradients/Add_3_grad/tuple/control_dependency*
T0*
_output_shapes

: 
*
transpose_a(*
transpose_b( 
t
(gradients/MatMul_3_grad/tuple/group_depsNoOp^gradients/MatMul_3_grad/MatMul!^gradients/MatMul_3_grad/MatMul_1
м
0gradients/MatMul_3_grad/tuple/control_dependencyIdentitygradients/MatMul_3_grad/MatMul)^gradients/MatMul_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_3_grad/MatMul*'
_output_shapes
:€€€€€€€€€ 
й
2gradients/MatMul_3_grad/tuple/control_dependency_1Identity gradients/MatMul_3_grad/MatMul_1)^gradients/MatMul_3_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_3_grad/MatMul_1*
_output_shapes

: 

Ґ
$gradients/Sigmoid_2_grad/SigmoidGradSigmoidGrad	Sigmoid_20gradients/MatMul_3_grad/tuple/control_dependency*'
_output_shapes
:€€€€€€€€€ *
T0
b
gradients/Add_2_grad/ShapeShapeMatMul_2*
T0*
out_type0*
_output_shapes
:
f
gradients/Add_2_grad/Shape_1Const*
valueB: *
dtype0*
_output_shapes
:
Ї
*gradients/Add_2_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_2_grad/Shapegradients/Add_2_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
±
gradients/Add_2_grad/SumSum$gradients/Sigmoid_2_grad/SigmoidGrad*gradients/Add_2_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Э
gradients/Add_2_grad/ReshapeReshapegradients/Add_2_grad/Sumgradients/Add_2_grad/Shape*'
_output_shapes
:€€€€€€€€€ *
T0*
Tshape0
µ
gradients/Add_2_grad/Sum_1Sum$gradients/Sigmoid_2_grad/SigmoidGrad,gradients/Add_2_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Ц
gradients/Add_2_grad/Reshape_1Reshapegradients/Add_2_grad/Sum_1gradients/Add_2_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
m
%gradients/Add_2_grad/tuple/group_depsNoOp^gradients/Add_2_grad/Reshape^gradients/Add_2_grad/Reshape_1
в
-gradients/Add_2_grad/tuple/control_dependencyIdentitygradients/Add_2_grad/Reshape&^gradients/Add_2_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_2_grad/Reshape*'
_output_shapes
:€€€€€€€€€ 
џ
/gradients/Add_2_grad/tuple/control_dependency_1Identitygradients/Add_2_grad/Reshape_1&^gradients/Add_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_2_grad/Reshape_1*
_output_shapes
: 
Ѕ
gradients/MatMul_2_grad/MatMulMatMul-gradients/Add_2_grad/tuple/control_dependencyl3_weights/read*
transpose_b(*
T0*(
_output_shapes
:€€€€€€€€€А*
transpose_a( 
і
 gradients/MatMul_2_grad/MatMul_1MatMul	Sigmoid_1-gradients/Add_2_grad/tuple/control_dependency*
T0*
_output_shapes
:	А *
transpose_a(*
transpose_b( 
t
(gradients/MatMul_2_grad/tuple/group_depsNoOp^gradients/MatMul_2_grad/MatMul!^gradients/MatMul_2_grad/MatMul_1
н
0gradients/MatMul_2_grad/tuple/control_dependencyIdentitygradients/MatMul_2_grad/MatMul)^gradients/MatMul_2_grad/tuple/group_deps*(
_output_shapes
:€€€€€€€€€А*
T0*1
_class'
%#loc:@gradients/MatMul_2_grad/MatMul
к
2gradients/MatMul_2_grad/tuple/control_dependency_1Identity gradients/MatMul_2_grad/MatMul_1)^gradients/MatMul_2_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_2_grad/MatMul_1*
_output_shapes
:	А 
£
$gradients/Sigmoid_1_grad/SigmoidGradSigmoidGrad	Sigmoid_10gradients/MatMul_2_grad/tuple/control_dependency*
T0*(
_output_shapes
:€€€€€€€€€А
b
gradients/Add_1_grad/ShapeShapeMatMul_1*
T0*
out_type0*
_output_shapes
:
g
gradients/Add_1_grad/Shape_1Const*
valueB:А*
dtype0*
_output_shapes
:
Ї
*gradients/Add_1_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_1_grad/Shapegradients/Add_1_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
±
gradients/Add_1_grad/SumSum$gradients/Sigmoid_1_grad/SigmoidGrad*gradients/Add_1_grad/BroadcastGradientArgs*
	keep_dims( *

Tidx0*
T0*
_output_shapes
:
Ю
gradients/Add_1_grad/ReshapeReshapegradients/Add_1_grad/Sumgradients/Add_1_grad/Shape*
T0*
Tshape0*(
_output_shapes
:€€€€€€€€€А
µ
gradients/Add_1_grad/Sum_1Sum$gradients/Sigmoid_1_grad/SigmoidGrad,gradients/Add_1_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Ч
gradients/Add_1_grad/Reshape_1Reshapegradients/Add_1_grad/Sum_1gradients/Add_1_grad/Shape_1*
T0*
Tshape0*
_output_shapes	
:А
m
%gradients/Add_1_grad/tuple/group_depsNoOp^gradients/Add_1_grad/Reshape^gradients/Add_1_grad/Reshape_1
г
-gradients/Add_1_grad/tuple/control_dependencyIdentitygradients/Add_1_grad/Reshape&^gradients/Add_1_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_1_grad/Reshape*(
_output_shapes
:€€€€€€€€€А
№
/gradients/Add_1_grad/tuple/control_dependency_1Identitygradients/Add_1_grad/Reshape_1&^gradients/Add_1_grad/tuple/group_deps*
_output_shapes	
:А*
T0*1
_class'
%#loc:@gradients/Add_1_grad/Reshape_1
Ѕ
gradients/MatMul_1_grad/MatMulMatMul-gradients/Add_1_grad/tuple/control_dependencyl2_weights/read*
T0*(
_output_shapes
:€€€€€€€€€А*
transpose_a( *
transpose_b(
≥
 gradients/MatMul_1_grad/MatMul_1MatMulSigmoid-gradients/Add_1_grad/tuple/control_dependency* 
_output_shapes
:
АА*
transpose_a(*
transpose_b( *
T0
t
(gradients/MatMul_1_grad/tuple/group_depsNoOp^gradients/MatMul_1_grad/MatMul!^gradients/MatMul_1_grad/MatMul_1
н
0gradients/MatMul_1_grad/tuple/control_dependencyIdentitygradients/MatMul_1_grad/MatMul)^gradients/MatMul_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_1_grad/MatMul*(
_output_shapes
:€€€€€€€€€А
л
2gradients/MatMul_1_grad/tuple/control_dependency_1Identity gradients/MatMul_1_grad/MatMul_1)^gradients/MatMul_1_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_1_grad/MatMul_1* 
_output_shapes
:
АА
Я
"gradients/Sigmoid_grad/SigmoidGradSigmoidGradSigmoid0gradients/MatMul_1_grad/tuple/control_dependency*(
_output_shapes
:€€€€€€€€€А*
T0
^
gradients/Add_grad/ShapeShapeMatMul*
_output_shapes
:*
T0*
out_type0
e
gradients/Add_grad/Shape_1Const*
valueB:А*
dtype0*
_output_shapes
:
і
(gradients/Add_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_grad/Shapegradients/Add_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
Ђ
gradients/Add_grad/SumSum"gradients/Sigmoid_grad/SigmoidGrad(gradients/Add_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0
Ш
gradients/Add_grad/ReshapeReshapegradients/Add_grad/Sumgradients/Add_grad/Shape*
T0*
Tshape0*(
_output_shapes
:€€€€€€€€€А
ѓ
gradients/Add_grad/Sum_1Sum"gradients/Sigmoid_grad/SigmoidGrad*gradients/Add_grad/BroadcastGradientArgs:1*
	keep_dims( *

Tidx0*
T0*
_output_shapes
:
С
gradients/Add_grad/Reshape_1Reshapegradients/Add_grad/Sum_1gradients/Add_grad/Shape_1*
_output_shapes	
:А*
T0*
Tshape0
g
#gradients/Add_grad/tuple/group_depsNoOp^gradients/Add_grad/Reshape^gradients/Add_grad/Reshape_1
џ
+gradients/Add_grad/tuple/control_dependencyIdentitygradients/Add_grad/Reshape$^gradients/Add_grad/tuple/group_deps*(
_output_shapes
:€€€€€€€€€А*
T0*-
_class#
!loc:@gradients/Add_grad/Reshape
‘
-gradients/Add_grad/tuple/control_dependency_1Identitygradients/Add_grad/Reshape_1$^gradients/Add_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_grad/Reshape_1*
_output_shapes	
:А
љ
gradients/MatMul_grad/MatMulMatMul+gradients/Add_grad/tuple/control_dependencyl1_weights/read*
T0*(
_output_shapes
:€€€€€€€€€Р*
transpose_a( *
transpose_b(
≥
gradients/MatMul_grad/MatMul_1MatMulPlaceholder+gradients/Add_grad/tuple/control_dependency* 
_output_shapes
:
РА*
transpose_a(*
transpose_b( *
T0
n
&gradients/MatMul_grad/tuple/group_depsNoOp^gradients/MatMul_grad/MatMul^gradients/MatMul_grad/MatMul_1
е
.gradients/MatMul_grad/tuple/control_dependencyIdentitygradients/MatMul_grad/MatMul'^gradients/MatMul_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/MatMul_grad/MatMul*(
_output_shapes
:€€€€€€€€€Р
г
0gradients/MatMul_grad/tuple/control_dependency_1Identitygradients/MatMul_grad/MatMul_1'^gradients/MatMul_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_grad/MatMul_1* 
_output_shapes
:
РА
z
beta1_power/initial_valueConst*
valueB
 *fff?*
_class
loc:@l1_bias*
dtype0*
_output_shapes
: 
Л
beta1_power
VariableV2*
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l1_bias*
	container *
shape: 
™
beta1_power/AssignAssignbeta1_powerbeta1_power/initial_value*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
f
beta1_power/readIdentitybeta1_power*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
z
beta2_power/initial_valueConst*
dtype0*
_output_shapes
: *
valueB
 *wЊ?*
_class
loc:@l1_bias
Л
beta2_power
VariableV2*
shared_name *
_class
loc:@l1_bias*
	container *
shape: *
dtype0*
_output_shapes
: 
™
beta2_power/AssignAssignbeta2_powerbeta2_power/initial_value*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: *
use_locking(
f
beta2_power/readIdentitybeta2_power*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
°
1l1_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l1_weights*
valueB"     *
dtype0*
_output_shapes
:
Л
'l1_weights/Adam/Initializer/zeros/ConstConst*
_class
loc:@l1_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
б
!l1_weights/Adam/Initializer/zerosFill1l1_weights/Adam/Initializer/zeros/shape_as_tensor'l1_weights/Adam/Initializer/zeros/Const*
T0*
_class
loc:@l1_weights*

index_type0* 
_output_shapes
:
РА
¶
l1_weights/Adam
VariableV2*
dtype0* 
_output_shapes
:
РА*
shared_name *
_class
loc:@l1_weights*
	container *
shape:
РА
«
l1_weights/Adam/AssignAssignl1_weights/Adam!l1_weights/Adam/Initializer/zeros*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights
{
l1_weights/Adam/readIdentityl1_weights/Adam*
T0*
_class
loc:@l1_weights* 
_output_shapes
:
РА
£
3l1_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l1_weights*
valueB"     *
dtype0*
_output_shapes
:
Н
)l1_weights/Adam_1/Initializer/zeros/ConstConst*
_class
loc:@l1_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
з
#l1_weights/Adam_1/Initializer/zerosFill3l1_weights/Adam_1/Initializer/zeros/shape_as_tensor)l1_weights/Adam_1/Initializer/zeros/Const* 
_output_shapes
:
РА*
T0*
_class
loc:@l1_weights*

index_type0
®
l1_weights/Adam_1
VariableV2*
_class
loc:@l1_weights*
	container *
shape:
РА*
dtype0* 
_output_shapes
:
РА*
shared_name 
Ќ
l1_weights/Adam_1/AssignAssignl1_weights/Adam_1#l1_weights/Adam_1/Initializer/zeros*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights

l1_weights/Adam_1/readIdentityl1_weights/Adam_1* 
_output_shapes
:
РА*
T0*
_class
loc:@l1_weights
Й
l1_bias/Adam/Initializer/zerosConst*
dtype0*
_output_shapes	
:А*
_class
loc:@l1_bias*
valueBА*    
Ц
l1_bias/Adam
VariableV2*
dtype0*
_output_shapes	
:А*
shared_name *
_class
loc:@l1_bias*
	container *
shape:А
ґ
l1_bias/Adam/AssignAssignl1_bias/Adaml1_bias/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А
m
l1_bias/Adam/readIdentityl1_bias/Adam*
_output_shapes	
:А*
T0*
_class
loc:@l1_bias
Л
 l1_bias/Adam_1/Initializer/zerosConst*
_class
loc:@l1_bias*
valueBА*    *
dtype0*
_output_shapes	
:А
Ш
l1_bias/Adam_1
VariableV2*
_class
loc:@l1_bias*
	container *
shape:А*
dtype0*
_output_shapes	
:А*
shared_name 
Љ
l1_bias/Adam_1/AssignAssignl1_bias/Adam_1 l1_bias/Adam_1/Initializer/zeros*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
q
l1_bias/Adam_1/readIdentityl1_bias/Adam_1*
_output_shapes	
:А*
T0*
_class
loc:@l1_bias
°
1l2_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l2_weights*
valueB"   А   *
dtype0*
_output_shapes
:
Л
'l2_weights/Adam/Initializer/zeros/ConstConst*
_class
loc:@l2_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
б
!l2_weights/Adam/Initializer/zerosFill1l2_weights/Adam/Initializer/zeros/shape_as_tensor'l2_weights/Adam/Initializer/zeros/Const* 
_output_shapes
:
АА*
T0*
_class
loc:@l2_weights*

index_type0
¶
l2_weights/Adam
VariableV2*
_class
loc:@l2_weights*
	container *
shape:
АА*
dtype0* 
_output_shapes
:
АА*
shared_name 
«
l2_weights/Adam/AssignAssignl2_weights/Adam!l2_weights/Adam/Initializer/zeros*
validate_shape(* 
_output_shapes
:
АА*
use_locking(*
T0*
_class
loc:@l2_weights
{
l2_weights/Adam/readIdentityl2_weights/Adam*
T0*
_class
loc:@l2_weights* 
_output_shapes
:
АА
£
3l2_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l2_weights*
valueB"   А   *
dtype0*
_output_shapes
:
Н
)l2_weights/Adam_1/Initializer/zeros/ConstConst*
_class
loc:@l2_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
з
#l2_weights/Adam_1/Initializer/zerosFill3l2_weights/Adam_1/Initializer/zeros/shape_as_tensor)l2_weights/Adam_1/Initializer/zeros/Const*
T0*
_class
loc:@l2_weights*

index_type0* 
_output_shapes
:
АА
®
l2_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@l2_weights*
	container *
shape:
АА*
dtype0* 
_output_shapes
:
АА
Ќ
l2_weights/Adam_1/AssignAssignl2_weights/Adam_1#l2_weights/Adam_1/Initializer/zeros*
validate_shape(* 
_output_shapes
:
АА*
use_locking(*
T0*
_class
loc:@l2_weights

l2_weights/Adam_1/readIdentityl2_weights/Adam_1* 
_output_shapes
:
АА*
T0*
_class
loc:@l2_weights
Й
l2_bias/Adam/Initializer/zerosConst*
_class
loc:@l2_bias*
valueBА*    *
dtype0*
_output_shapes	
:А
Ц
l2_bias/Adam
VariableV2*
dtype0*
_output_shapes	
:А*
shared_name *
_class
loc:@l2_bias*
	container *
shape:А
ґ
l2_bias/Adam/AssignAssignl2_bias/Adaml2_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l2_bias
m
l2_bias/Adam/readIdentityl2_bias/Adam*
T0*
_class
loc:@l2_bias*
_output_shapes	
:А
Л
 l2_bias/Adam_1/Initializer/zerosConst*
_class
loc:@l2_bias*
valueBА*    *
dtype0*
_output_shapes	
:А
Ш
l2_bias/Adam_1
VariableV2*
dtype0*
_output_shapes	
:А*
shared_name *
_class
loc:@l2_bias*
	container *
shape:А
Љ
l2_bias/Adam_1/AssignAssignl2_bias/Adam_1 l2_bias/Adam_1/Initializer/zeros*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
q
l2_bias/Adam_1/readIdentityl2_bias/Adam_1*
T0*
_class
loc:@l2_bias*
_output_shapes	
:А
°
1l3_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l3_weights*
valueB"А       *
dtype0*
_output_shapes
:
Л
'l3_weights/Adam/Initializer/zeros/ConstConst*
_class
loc:@l3_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
а
!l3_weights/Adam/Initializer/zerosFill1l3_weights/Adam/Initializer/zeros/shape_as_tensor'l3_weights/Adam/Initializer/zeros/Const*
_output_shapes
:	А *
T0*
_class
loc:@l3_weights*

index_type0
§
l3_weights/Adam
VariableV2*
dtype0*
_output_shapes
:	А *
shared_name *
_class
loc:@l3_weights*
	container *
shape:	А 
∆
l3_weights/Adam/AssignAssignl3_weights/Adam!l3_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А 
z
l3_weights/Adam/readIdentityl3_weights/Adam*
T0*
_class
loc:@l3_weights*
_output_shapes
:	А 
£
3l3_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
_class
loc:@l3_weights*
valueB"А       
Н
)l3_weights/Adam_1/Initializer/zeros/ConstConst*
_class
loc:@l3_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
ж
#l3_weights/Adam_1/Initializer/zerosFill3l3_weights/Adam_1/Initializer/zeros/shape_as_tensor)l3_weights/Adam_1/Initializer/zeros/Const*
T0*
_class
loc:@l3_weights*

index_type0*
_output_shapes
:	А 
¶
l3_weights/Adam_1
VariableV2*
dtype0*
_output_shapes
:	А *
shared_name *
_class
loc:@l3_weights*
	container *
shape:	А 
ћ
l3_weights/Adam_1/AssignAssignl3_weights/Adam_1#l3_weights/Adam_1/Initializer/zeros*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А *
use_locking(
~
l3_weights/Adam_1/readIdentityl3_weights/Adam_1*
_output_shapes
:	А *
T0*
_class
loc:@l3_weights
З
l3_bias/Adam/Initializer/zerosConst*
_class
loc:@l3_bias*
valueB *    *
dtype0*
_output_shapes
: 
Ф
l3_bias/Adam
VariableV2*
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l3_bias*
	container *
shape: 
µ
l3_bias/Adam/AssignAssignl3_bias/Adaml3_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
l
l3_bias/Adam/readIdentityl3_bias/Adam*
T0*
_class
loc:@l3_bias*
_output_shapes
: 
Й
 l3_bias/Adam_1/Initializer/zerosConst*
_class
loc:@l3_bias*
valueB *    *
dtype0*
_output_shapes
: 
Ц
l3_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@l3_bias*
	container *
shape: *
dtype0*
_output_shapes
: 
ї
l3_bias/Adam_1/AssignAssignl3_bias/Adam_1 l3_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
p
l3_bias/Adam_1/readIdentityl3_bias/Adam_1*
T0*
_class
loc:@l3_bias*
_output_shapes
: 
Ч
"out_weights/Adam/Initializer/zerosConst*
dtype0*
_output_shapes

: 
*
_class
loc:@out_weights*
valueB 
*    
§
out_weights/Adam
VariableV2*
shared_name *
_class
loc:@out_weights*
	container *
shape
: 
*
dtype0*
_output_shapes

: 

…
out_weights/Adam/AssignAssignout_weights/Adam"out_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

|
out_weights/Adam/readIdentityout_weights/Adam*
T0*
_class
loc:@out_weights*
_output_shapes

: 

Щ
$out_weights/Adam_1/Initializer/zerosConst*
_class
loc:@out_weights*
valueB 
*    *
dtype0*
_output_shapes

: 

¶
out_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@out_weights*
	container *
shape
: 
*
dtype0*
_output_shapes

: 

ѕ
out_weights/Adam_1/AssignAssignout_weights/Adam_1$out_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

А
out_weights/Adam_1/readIdentityout_weights/Adam_1*
_output_shapes

: 
*
T0*
_class
loc:@out_weights
Й
out_bias/Adam/Initializer/zerosConst*
dtype0*
_output_shapes
:
*
_class
loc:@out_bias*
valueB
*    
Ц
out_bias/Adam
VariableV2*
_class
loc:@out_bias*
	container *
shape:
*
dtype0*
_output_shapes
:
*
shared_name 
є
out_bias/Adam/AssignAssignout_bias/Adamout_bias/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

o
out_bias/Adam/readIdentityout_bias/Adam*
_output_shapes
:
*
T0*
_class
loc:@out_bias
Л
!out_bias/Adam_1/Initializer/zerosConst*
_class
loc:@out_bias*
valueB
*    *
dtype0*
_output_shapes
:

Ш
out_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@out_bias*
	container *
shape:
*
dtype0*
_output_shapes
:

њ
out_bias/Adam_1/AssignAssignout_bias/Adam_1!out_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
s
out_bias/Adam_1/readIdentityout_bias/Adam_1*
T0*
_class
loc:@out_bias*
_output_shapes
:

W
Adam/learning_rateConst*
dtype0*
_output_shapes
: *
valueB
 *oГ:
O

Adam/beta1Const*
valueB
 *fff?*
dtype0*
_output_shapes
: 
O

Adam/beta2Const*
dtype0*
_output_shapes
: *
valueB
 *wЊ?
Q
Adam/epsilonConst*
dtype0*
_output_shapes
: *
valueB
 *wћ+2
ё
 Adam/update_l1_weights/ApplyAdam	ApplyAdam
l1_weightsl1_weights/Adaml1_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon0gradients/MatMul_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l1_weights*
use_nesterov( * 
_output_shapes
:
РА
«
Adam/update_l1_bias/ApplyAdam	ApplyAdaml1_biasl1_bias/Adaml1_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon-gradients/Add_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l1_bias*
use_nesterov( *
_output_shapes	
:А
а
 Adam/update_l2_weights/ApplyAdam	ApplyAdam
l2_weightsl2_weights/Adaml2_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_1_grad/tuple/control_dependency_1*
T0*
_class
loc:@l2_weights*
use_nesterov( * 
_output_shapes
:
АА*
use_locking( 
…
Adam/update_l2_bias/ApplyAdam	ApplyAdaml2_biasl2_bias/Adaml2_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_1_grad/tuple/control_dependency_1*
T0*
_class
loc:@l2_bias*
use_nesterov( *
_output_shapes	
:А*
use_locking( 
я
 Adam/update_l3_weights/ApplyAdam	ApplyAdam
l3_weightsl3_weights/Adaml3_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_2_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l3_weights*
use_nesterov( *
_output_shapes
:	А 
»
Adam/update_l3_bias/ApplyAdam	ApplyAdaml3_biasl3_bias/Adaml3_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_2_grad/tuple/control_dependency_1*
use_nesterov( *
_output_shapes
: *
use_locking( *
T0*
_class
loc:@l3_bias
г
!Adam/update_out_weights/ApplyAdam	ApplyAdamout_weightsout_weights/Adamout_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_3_grad/tuple/control_dependency_1*
use_nesterov( *
_output_shapes

: 
*
use_locking( *
T0*
_class
loc:@out_weights
Ќ
Adam/update_out_bias/ApplyAdam	ApplyAdamout_biasout_bias/Adamout_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_3_grad/tuple/control_dependency_1*
T0*
_class
loc:@out_bias*
use_nesterov( *
_output_shapes
:
*
use_locking( 
ш
Adam/mulMulbeta1_power/read
Adam/beta1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
Т
Adam/AssignAssignbeta1_powerAdam/mul*
use_locking( *
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
ъ

Adam/mul_1Mulbeta2_power/read
Adam/beta2^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
Ц
Adam/Assign_1Assignbeta2_power
Adam/mul_1*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: *
use_locking( 
Є
AdamNoOp^Adam/Assign^Adam/Assign_1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam
Ў
initNoOp^beta1_power/Assign^beta2_power/Assign^l1_bias/Adam/Assign^l1_bias/Adam_1/Assign^l1_bias/Assign^l1_weights/Adam/Assign^l1_weights/Adam_1/Assign^l1_weights/Assign^l2_bias/Adam/Assign^l2_bias/Adam_1/Assign^l2_bias/Assign^l2_weights/Adam/Assign^l2_weights/Adam_1/Assign^l2_weights/Assign^l3_bias/Adam/Assign^l3_bias/Adam_1/Assign^l3_bias/Assign^l3_weights/Adam/Assign^l3_weights/Adam_1/Assign^l3_weights/Assign^out_bias/Adam/Assign^out_bias/Adam_1/Assign^out_bias/Assign^out_weights/Adam/Assign^out_weights/Adam_1/Assign^out_weights/Assign
R
ArgMax/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
v
ArgMaxArgMaxAdd_3ArgMax/dimension*

Tidx0*
T0*
output_type0	*#
_output_shapes
:€€€€€€€€€
T
ArgMax_1/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
w
ArgMax_1ArgMaxPlaceholder_1ArgMax_1/dimension*
T0*
output_type0	*
_output_shapes
:*

Tidx0
C
EqualEqualArgMaxArgMax_1*
T0	*
_output_shapes
:
U
CastCastEqual*

SrcT0
*
Truncate( *
_output_shapes
:*

DstT0
3
RankRankCast*
T0*
_output_shapes
: 
M
range/startConst*
value	B : *
dtype0*
_output_shapes
: 
M
range/deltaConst*
value	B :*
dtype0*
_output_shapes
: 
_
rangeRangerange/startRankrange/delta*

Tidx0*#
_output_shapes
:€€€€€€€€€
Y
Mean_1MeanCastrange*
	keep_dims( *

Tidx0*
T0*
_output_shapes
: 
Y
save/filename/inputConst*
dtype0*
_output_shapes
: *
valueB Bmodel
n
save/filenamePlaceholderWithDefaultsave/filename/input*
dtype0*
_output_shapes
: *
shape: 
e

save/ConstPlaceholderWithDefaultsave/filename*
shape: *
dtype0*
_output_shapes
: 
ё
save/SaveV2/tensor_namesConst*С
valueЗBДBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:
Ч
save/SaveV2/shape_and_slicesConst*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B *
dtype0*
_output_shapes
:
€
save/SaveV2SaveV2
save/Constsave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesbeta1_powerbeta2_powerl1_biasl1_bias/Adaml1_bias/Adam_1
l1_weightsl1_weights/Adaml1_weights/Adam_1l2_biasl2_bias/Adaml2_bias/Adam_1
l2_weightsl2_weights/Adaml2_weights/Adam_1l3_biasl3_bias/Adaml3_bias/Adam_1
l3_weightsl3_weights/Adaml3_weights/Adam_1out_biasout_bias/Adamout_bias/Adam_1out_weightsout_weights/Adamout_weights/Adam_1*(
dtypes
2
}
save/control_dependencyIdentity
save/Const^save/SaveV2*
T0*
_class
loc:@save/Const*
_output_shapes
: 
р
save/RestoreV2/tensor_namesConst"/device:CPU:0*С
valueЗBДBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:
©
save/RestoreV2/shape_and_slicesConst"/device:CPU:0*
dtype0*
_output_shapes
:*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B 
Ь
save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*|
_output_shapesj
h::::::::::::::::::::::::::*(
dtypes
2
Ш
save/AssignAssignbeta1_powersave/RestoreV2*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: *
use_locking(
Ь
save/Assign_1Assignbeta2_powersave/RestoreV2:1*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l1_bias
Э
save/Assign_2Assignl1_biassave/RestoreV2:2*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
Ґ
save/Assign_3Assignl1_bias/Adamsave/RestoreV2:3*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l1_bias
§
save/Assign_4Assignl1_bias/Adam_1save/RestoreV2:4*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А
®
save/Assign_5Assign
l1_weightssave/RestoreV2:5*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА
≠
save/Assign_6Assignl1_weights/Adamsave/RestoreV2:6*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА*
use_locking(
ѓ
save/Assign_7Assignl1_weights/Adam_1save/RestoreV2:7*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА*
use_locking(
Э
save/Assign_8Assignl2_biassave/RestoreV2:8*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
Ґ
save/Assign_9Assignl2_bias/Adamsave/RestoreV2:9*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А
¶
save/Assign_10Assignl2_bias/Adam_1save/RestoreV2:10*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
™
save/Assign_11Assign
l2_weightssave/RestoreV2:11*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
ѓ
save/Assign_12Assignl2_weights/Adamsave/RestoreV2:12*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
±
save/Assign_13Assignl2_weights/Adam_1save/RestoreV2:13*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
Ю
save/Assign_14Assignl3_biassave/RestoreV2:14*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
£
save/Assign_15Assignl3_bias/Adamsave/RestoreV2:15*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
•
save/Assign_16Assignl3_bias/Adam_1save/RestoreV2:16*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
©
save/Assign_17Assign
l3_weightssave/RestoreV2:17*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
Ѓ
save/Assign_18Assignl3_weights/Adamsave/RestoreV2:18*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
∞
save/Assign_19Assignl3_weights/Adam_1save/RestoreV2:19*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
†
save/Assign_20Assignout_biassave/RestoreV2:20*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:
*
use_locking(
•
save/Assign_21Assignout_bias/Adamsave/RestoreV2:21*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
І
save/Assign_22Assignout_bias/Adam_1save/RestoreV2:22*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:
*
use_locking(
™
save/Assign_23Assignout_weightssave/RestoreV2:23*
validate_shape(*
_output_shapes

: 
*
use_locking(*
T0*
_class
loc:@out_weights
ѓ
save/Assign_24Assignout_weights/Adamsave/RestoreV2:24*
validate_shape(*
_output_shapes

: 
*
use_locking(*
T0*
_class
loc:@out_weights
±
save/Assign_25Assignout_weights/Adam_1save/RestoreV2:25*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
∆
save/restore_allNoOp^save/Assign^save/Assign_1^save/Assign_10^save/Assign_11^save/Assign_12^save/Assign_13^save/Assign_14^save/Assign_15^save/Assign_16^save/Assign_17^save/Assign_18^save/Assign_19^save/Assign_2^save/Assign_20^save/Assign_21^save/Assign_22^save/Assign_23^save/Assign_24^save/Assign_25^save/Assign_3^save/Assign_4^save/Assign_5^save/Assign_6^save/Assign_7^save/Assign_8^save/Assign_9"&aЏМню      (c	A}‘qУ„AJаэ
Жя
:
Add
x"T
y"T
z"T"
Ttype:
2	
о
	ApplyAdam
var"TА	
m"TА	
v"TА
beta1_power"T
beta2_power"T
lr"T

beta1"T

beta2"T
epsilon"T	
grad"T
out"TА" 
Ttype:
2	"
use_lockingbool( "
use_nesterovbool( 
Ы
ArgMax

input"T
	dimension"Tidx
output"output_type" 
Ttype:
2	"
Tidxtype0:
2	"
output_typetype0	:
2	
x
Assign
ref"TА

value"T

output_ref"TА"	
Ttype"
validate_shapebool("
use_lockingbool(Ш
R
BroadcastGradientArgs
s0"T
s1"T
r0"T
r1"T"
Ttype0:
2	
N
Cast	
x"SrcT	
y"DstT"
SrcTtype"
DstTtype"
Truncatebool( 
h
ConcatV2
values"T*N
axis"Tidx
output"T"
Nint(0"	
Ttype"
Tidxtype0:
2	
8
Const
output"dtype"
valuetensor"
dtypetype
B
Equal
x"T
y"T
z
"
Ttype:
2	
Р
W

ExpandDims

input"T
dim"Tdim
output"T"	
Ttype"
Tdimtype0:
2	
^
Fill
dims"
index_type

value"T
output"T"	
Ttype"

index_typetype0:
2	
?
FloorDiv
x"T
y"T
z"T"
Ttype:
2	
.
Identity

input"T
output"T"	
Ttype
?

LogSoftmax
logits"T

logsoftmax"T"
Ttype:
2
q
MatMul
a"T
b"T
product"T"
transpose_abool( "
transpose_bbool( "
Ttype:

2	
8
Maximum
x"T
y"T
z"T"
Ttype:

2	
Н
Mean

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
=
Mul
x"T
y"T
z"T"
Ttype:
2	Р
.
Neg
x"T
y"T"
Ttype:

2	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
X
PlaceholderWithDefault
input"dtype
output"dtype"
dtypetype"
shapeshape
Н
Prod

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
Е
RandomStandardNormal

shape"T
output"dtype"
seedint "
seed2int "
dtypetype:
2"
Ttype:
2	И
a
Range
start"Tidx
limit"Tidx
delta"Tidx
output"Tidx"
Tidxtype0:	
2	
)
Rank

input"T

output"	
Ttype
>
RealDiv
x"T
y"T
z"T"
Ttype:
2	
[
Reshape
tensor"T
shape"Tshape
output"T"	
Ttype"
Tshapetype0:
2	
o
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0И
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0И
P
Shape

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
0
Sigmoid
x"T
y"T"
Ttype:

2
=
SigmoidGrad
y"T
dy"T
z"T"
Ttype:

2
a
Slice

input"T
begin"Index
size"Index
output"T"	
Ttype"
Indextype:
2	
j
SoftmaxCrossEntropyWithLogits
features"T
labels"T	
loss"T
backprop"T"
Ttype:
2
:
Sub
x"T
y"T
z"T"
Ttype:
2	
М
Sum

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	
c
Tile

input"T
	multiples"
Tmultiples
output"T"	
Ttype"

Tmultiplestype0:
2	
s

VariableV2
ref"dtypeА"
shapeshape"
dtypetype"
	containerstring "
shared_namestring И
&
	ZerosLike
x"T
y"T"	
Ttype*1.14.02v1.14.0-rc1-22-gaf24dc91b5я»
p
PlaceholderPlaceholder*
dtype0*(
_output_shapes
:€€€€€€€€€Р*
shape:€€€€€€€€€Р
R
Placeholder_1Placeholder*
dtype0*
_output_shapes
:*
shape:
d
random_normal/shapeConst*
valueB"     *
dtype0*
_output_shapes
:
W
random_normal/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
Y
random_normal/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
†
"random_normal/RandomStandardNormalRandomStandardNormalrandom_normal/shape*
T0*
dtype0*
seed2 * 
_output_shapes
:
РА*

seed 
}
random_normal/mulMul"random_normal/RandomStandardNormalrandom_normal/stddev*
T0* 
_output_shapes
:
РА
f
random_normalAddrandom_normal/mulrandom_normal/mean*
T0* 
_output_shapes
:
РА
В

l1_weights
VariableV2*
dtype0*
	container * 
_output_shapes
:
РА*
shape:
РА*
shared_name 
©
l1_weights/AssignAssign
l1_weightsrandom_normal*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА
q
l1_weights/readIdentity
l1_weights*
T0*
_class
loc:@l1_weights* 
_output_shapes
:
РА
`
random_normal_1/shapeConst*
dtype0*
_output_shapes
:*
valueB:А
Y
random_normal_1/meanConst*
dtype0*
_output_shapes
: *
valueB
 *    
[
random_normal_1/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
Я
$random_normal_1/RandomStandardNormalRandomStandardNormalrandom_normal_1/shape*
T0*
dtype0*
seed2 *
_output_shapes	
:А*

seed 
~
random_normal_1/mulMul$random_normal_1/RandomStandardNormalrandom_normal_1/stddev*
T0*
_output_shapes	
:А
g
random_normal_1Addrandom_normal_1/mulrandom_normal_1/mean*
T0*
_output_shapes	
:А
u
l1_bias
VariableV2*
dtype0*
	container *
_output_shapes	
:А*
shape:А*
shared_name 
Э
l1_bias/AssignAssignl1_biasrandom_normal_1*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l1_bias
c
l1_bias/readIdentityl1_bias*
_output_shapes	
:А*
T0*
_class
loc:@l1_bias
f
random_normal_2/shapeConst*
valueB"   А   *
dtype0*
_output_shapes
:
Y
random_normal_2/meanConst*
dtype0*
_output_shapes
: *
valueB
 *    
[
random_normal_2/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
§
$random_normal_2/RandomStandardNormalRandomStandardNormalrandom_normal_2/shape*

seed *
T0*
dtype0*
seed2 * 
_output_shapes
:
АА
Г
random_normal_2/mulMul$random_normal_2/RandomStandardNormalrandom_normal_2/stddev*
T0* 
_output_shapes
:
АА
l
random_normal_2Addrandom_normal_2/mulrandom_normal_2/mean* 
_output_shapes
:
АА*
T0
В

l2_weights
VariableV2*
dtype0*
	container * 
_output_shapes
:
АА*
shape:
АА*
shared_name 
Ђ
l2_weights/AssignAssign
l2_weightsrandom_normal_2*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
q
l2_weights/readIdentity
l2_weights*
T0*
_class
loc:@l2_weights* 
_output_shapes
:
АА
`
random_normal_3/shapeConst*
dtype0*
_output_shapes
:*
valueB:А
Y
random_normal_3/meanConst*
dtype0*
_output_shapes
: *
valueB
 *    
[
random_normal_3/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Я
$random_normal_3/RandomStandardNormalRandomStandardNormalrandom_normal_3/shape*
dtype0*
seed2 *
_output_shapes	
:А*

seed *
T0
~
random_normal_3/mulMul$random_normal_3/RandomStandardNormalrandom_normal_3/stddev*
_output_shapes	
:А*
T0
g
random_normal_3Addrandom_normal_3/mulrandom_normal_3/mean*
T0*
_output_shapes	
:А
u
l2_bias
VariableV2*
shape:А*
shared_name *
dtype0*
	container *
_output_shapes	
:А
Э
l2_bias/AssignAssignl2_biasrandom_normal_3*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
c
l2_bias/readIdentityl2_bias*
T0*
_class
loc:@l2_bias*
_output_shapes	
:А
f
random_normal_4/shapeConst*
dtype0*
_output_shapes
:*
valueB"А       
Y
random_normal_4/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_4/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
£
$random_normal_4/RandomStandardNormalRandomStandardNormalrandom_normal_4/shape*
dtype0*
seed2 *
_output_shapes
:	А *

seed *
T0
В
random_normal_4/mulMul$random_normal_4/RandomStandardNormalrandom_normal_4/stddev*
T0*
_output_shapes
:	А 
k
random_normal_4Addrandom_normal_4/mulrandom_normal_4/mean*
T0*
_output_shapes
:	А 
А

l3_weights
VariableV2*
shared_name *
dtype0*
	container *
_output_shapes
:	А *
shape:	А 
™
l3_weights/AssignAssign
l3_weightsrandom_normal_4*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А *
use_locking(
p
l3_weights/readIdentity
l3_weights*
T0*
_class
loc:@l3_weights*
_output_shapes
:	А 
_
random_normal_5/shapeConst*
dtype0*
_output_shapes
:*
valueB: 
Y
random_normal_5/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_5/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
Ю
$random_normal_5/RandomStandardNormalRandomStandardNormalrandom_normal_5/shape*
T0*
dtype0*
seed2 *
_output_shapes
: *

seed 
}
random_normal_5/mulMul$random_normal_5/RandomStandardNormalrandom_normal_5/stddev*
T0*
_output_shapes
: 
f
random_normal_5Addrandom_normal_5/mulrandom_normal_5/mean*
T0*
_output_shapes
: 
s
l3_bias
VariableV2*
shared_name *
dtype0*
	container *
_output_shapes
: *
shape: 
Ь
l3_bias/AssignAssignl3_biasrandom_normal_5*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
b
l3_bias/readIdentityl3_bias*
_output_shapes
: *
T0*
_class
loc:@l3_bias
f
random_normal_6/shapeConst*
valueB"    
   *
dtype0*
_output_shapes
:
Y
random_normal_6/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_6/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  А?
Ґ
$random_normal_6/RandomStandardNormalRandomStandardNormalrandom_normal_6/shape*

seed *
T0*
dtype0*
seed2 *
_output_shapes

: 

Б
random_normal_6/mulMul$random_normal_6/RandomStandardNormalrandom_normal_6/stddev*
T0*
_output_shapes

: 

j
random_normal_6Addrandom_normal_6/mulrandom_normal_6/mean*
_output_shapes

: 
*
T0

out_weights
VariableV2*
shared_name *
dtype0*
	container *
_output_shapes

: 
*
shape
: 

ђ
out_weights/AssignAssignout_weightsrandom_normal_6*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

r
out_weights/readIdentityout_weights*
T0*
_class
loc:@out_weights*
_output_shapes

: 

_
random_normal_7/shapeConst*
dtype0*
_output_shapes
:*
valueB:

Y
random_normal_7/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_7/stddevConst*
valueB
 *  А?*
dtype0*
_output_shapes
: 
Ю
$random_normal_7/RandomStandardNormalRandomStandardNormalrandom_normal_7/shape*
T0*
dtype0*
seed2 *
_output_shapes
:
*

seed 
}
random_normal_7/mulMul$random_normal_7/RandomStandardNormalrandom_normal_7/stddev*
T0*
_output_shapes
:

f
random_normal_7Addrandom_normal_7/mulrandom_normal_7/mean*
T0*
_output_shapes
:

t
out_bias
VariableV2*
shape:
*
shared_name *
dtype0*
	container *
_output_shapes
:

Я
out_bias/AssignAssignout_biasrandom_normal_7*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

e
out_bias/readIdentityout_bias*
_output_shapes
:
*
T0*
_class
loc:@out_bias
З
MatMulMatMulPlaceholderl1_weights/read*
T0*
transpose_a( *(
_output_shapes
:€€€€€€€€€А*
transpose_b( 
S
AddAddMatMull1_bias/read*(
_output_shapes
:€€€€€€€€€А*
T0
J
SigmoidSigmoidAdd*(
_output_shapes
:€€€€€€€€€А*
T0
Е
MatMul_1MatMulSigmoidl2_weights/read*
transpose_a( *(
_output_shapes
:€€€€€€€€€А*
transpose_b( *
T0
W
Add_1AddMatMul_1l2_bias/read*
T0*(
_output_shapes
:€€€€€€€€€А
N
	Sigmoid_1SigmoidAdd_1*
T0*(
_output_shapes
:€€€€€€€€€А
Ж
MatMul_2MatMul	Sigmoid_1l3_weights/read*
T0*
transpose_a( *'
_output_shapes
:€€€€€€€€€ *
transpose_b( 
V
Add_2AddMatMul_2l3_bias/read*
T0*'
_output_shapes
:€€€€€€€€€ 
M
	Sigmoid_2SigmoidAdd_2*
T0*'
_output_shapes
:€€€€€€€€€ 
З
MatMul_3MatMul	Sigmoid_2out_weights/read*
T0*
transpose_a( *'
_output_shapes
:€€€€€€€€€
*
transpose_b( 
W
Add_3AddMatMul_3out_bias/read*'
_output_shapes
:€€€€€€€€€
*
T0
h
&softmax_cross_entropy_with_logits/RankConst*
value	B :*
dtype0*
_output_shapes
: 
l
'softmax_cross_entropy_with_logits/ShapeShapeAdd_3*
_output_shapes
:*
T0*
out_type0
j
(softmax_cross_entropy_with_logits/Rank_1Const*
value	B :*
dtype0*
_output_shapes
: 
n
)softmax_cross_entropy_with_logits/Shape_1ShapeAdd_3*
_output_shapes
:*
T0*
out_type0
i
'softmax_cross_entropy_with_logits/Sub/yConst*
value	B :*
dtype0*
_output_shapes
: 
†
%softmax_cross_entropy_with_logits/SubSub(softmax_cross_entropy_with_logits/Rank_1'softmax_cross_entropy_with_logits/Sub/y*
T0*
_output_shapes
: 
Ц
-softmax_cross_entropy_with_logits/Slice/beginPack%softmax_cross_entropy_with_logits/Sub*
N*
_output_shapes
:*
T0*

axis 
v
,softmax_cross_entropy_with_logits/Slice/sizeConst*
valueB:*
dtype0*
_output_shapes
:
к
'softmax_cross_entropy_with_logits/SliceSlice)softmax_cross_entropy_with_logits/Shape_1-softmax_cross_entropy_with_logits/Slice/begin,softmax_cross_entropy_with_logits/Slice/size*
T0*
Index0*
_output_shapes
:
Д
1softmax_cross_entropy_with_logits/concat/values_0Const*
valueB:
€€€€€€€€€*
dtype0*
_output_shapes
:
o
-softmax_cross_entropy_with_logits/concat/axisConst*
dtype0*
_output_shapes
: *
value	B : 
щ
(softmax_cross_entropy_with_logits/concatConcatV21softmax_cross_entropy_with_logits/concat/values_0'softmax_cross_entropy_with_logits/Slice-softmax_cross_entropy_with_logits/concat/axis*
T0*
N*
_output_shapes
:*

Tidx0
Ѓ
)softmax_cross_entropy_with_logits/ReshapeReshapeAdd_3(softmax_cross_entropy_with_logits/concat*
T0*
Tshape0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
`
(softmax_cross_entropy_with_logits/Rank_2RankPlaceholder_1*
T0*
_output_shapes
: 

)softmax_cross_entropy_with_logits/Shape_2ShapePlaceholder_1*
T0*
out_type0*#
_output_shapes
:€€€€€€€€€
k
)softmax_cross_entropy_with_logits/Sub_1/yConst*
value	B :*
dtype0*
_output_shapes
: 
§
'softmax_cross_entropy_with_logits/Sub_1Sub(softmax_cross_entropy_with_logits/Rank_2)softmax_cross_entropy_with_logits/Sub_1/y*
T0*
_output_shapes
: 
Ъ
/softmax_cross_entropy_with_logits/Slice_1/beginPack'softmax_cross_entropy_with_logits/Sub_1*
N*
_output_shapes
:*
T0*

axis 
x
.softmax_cross_entropy_with_logits/Slice_1/sizeConst*
valueB:*
dtype0*
_output_shapes
:
р
)softmax_cross_entropy_with_logits/Slice_1Slice)softmax_cross_entropy_with_logits/Shape_2/softmax_cross_entropy_with_logits/Slice_1/begin.softmax_cross_entropy_with_logits/Slice_1/size*
T0*
Index0*
_output_shapes
:
Ж
3softmax_cross_entropy_with_logits/concat_1/values_0Const*
valueB:
€€€€€€€€€*
dtype0*
_output_shapes
:
q
/softmax_cross_entropy_with_logits/concat_1/axisConst*
dtype0*
_output_shapes
: *
value	B : 
Б
*softmax_cross_entropy_with_logits/concat_1ConcatV23softmax_cross_entropy_with_logits/concat_1/values_0)softmax_cross_entropy_with_logits/Slice_1/softmax_cross_entropy_with_logits/concat_1/axis*
N*
_output_shapes
:*

Tidx0*
T0
Ї
+softmax_cross_entropy_with_logits/Reshape_1ReshapePlaceholder_1*softmax_cross_entropy_with_logits/concat_1*
T0*
Tshape0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
д
!softmax_cross_entropy_with_logitsSoftmaxCrossEntropyWithLogits)softmax_cross_entropy_with_logits/Reshape+softmax_cross_entropy_with_logits/Reshape_1*
T0*?
_output_shapes-
+:€€€€€€€€€:€€€€€€€€€€€€€€€€€€
k
)softmax_cross_entropy_with_logits/Sub_2/yConst*
value	B :*
dtype0*
_output_shapes
: 
Ґ
'softmax_cross_entropy_with_logits/Sub_2Sub&softmax_cross_entropy_with_logits/Rank)softmax_cross_entropy_with_logits/Sub_2/y*
T0*
_output_shapes
: 
y
/softmax_cross_entropy_with_logits/Slice_2/beginConst*
dtype0*
_output_shapes
:*
valueB: 
Щ
.softmax_cross_entropy_with_logits/Slice_2/sizePack'softmax_cross_entropy_with_logits/Sub_2*
T0*

axis *
N*
_output_shapes
:
о
)softmax_cross_entropy_with_logits/Slice_2Slice'softmax_cross_entropy_with_logits/Shape/softmax_cross_entropy_with_logits/Slice_2/begin.softmax_cross_entropy_with_logits/Slice_2/size*
T0*
Index0*
_output_shapes
:
ј
+softmax_cross_entropy_with_logits/Reshape_2Reshape!softmax_cross_entropy_with_logits)softmax_cross_entropy_with_logits/Slice_2*
T0*
Tshape0*#
_output_shapes
:€€€€€€€€€
O
ConstConst*
valueB: *
dtype0*
_output_shapes
:
~
MeanMean+softmax_cross_entropy_with_logits/Reshape_2Const*
T0*
_output_shapes
: *

Tidx0*
	keep_dims( 
R
gradients/ShapeConst*
valueB *
dtype0*
_output_shapes
: 
X
gradients/grad_ys_0Const*
valueB
 *  А?*
dtype0*
_output_shapes
: 
o
gradients/FillFillgradients/Shapegradients/grad_ys_0*
T0*

index_type0*
_output_shapes
: 
k
!gradients/Mean_grad/Reshape/shapeConst*
valueB:*
dtype0*
_output_shapes
:
М
gradients/Mean_grad/ReshapeReshapegradients/Fill!gradients/Mean_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
:
Д
gradients/Mean_grad/ShapeShape+softmax_cross_entropy_with_logits/Reshape_2*
T0*
out_type0*
_output_shapes
:
Ш
gradients/Mean_grad/TileTilegradients/Mean_grad/Reshapegradients/Mean_grad/Shape*#
_output_shapes
:€€€€€€€€€*

Tmultiples0*
T0
Ж
gradients/Mean_grad/Shape_1Shape+softmax_cross_entropy_with_logits/Reshape_2*
T0*
out_type0*
_output_shapes
:
^
gradients/Mean_grad/Shape_2Const*
valueB *
dtype0*
_output_shapes
: 
c
gradients/Mean_grad/ConstConst*
valueB: *
dtype0*
_output_shapes
:
Ц
gradients/Mean_grad/ProdProdgradients/Mean_grad/Shape_1gradients/Mean_grad/Const*
_output_shapes
: *

Tidx0*
	keep_dims( *
T0
e
gradients/Mean_grad/Const_1Const*
valueB: *
dtype0*
_output_shapes
:
Ъ
gradients/Mean_grad/Prod_1Prodgradients/Mean_grad/Shape_2gradients/Mean_grad/Const_1*
_output_shapes
: *

Tidx0*
	keep_dims( *
T0
_
gradients/Mean_grad/Maximum/yConst*
value	B :*
dtype0*
_output_shapes
: 
В
gradients/Mean_grad/MaximumMaximumgradients/Mean_grad/Prod_1gradients/Mean_grad/Maximum/y*
_output_shapes
: *
T0
А
gradients/Mean_grad/floordivFloorDivgradients/Mean_grad/Prodgradients/Mean_grad/Maximum*
_output_shapes
: *
T0
~
gradients/Mean_grad/CastCastgradients/Mean_grad/floordiv*

SrcT0*
Truncate( *

DstT0*
_output_shapes
: 
И
gradients/Mean_grad/truedivRealDivgradients/Mean_grad/Tilegradients/Mean_grad/Cast*#
_output_shapes
:€€€€€€€€€*
T0
°
@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ShapeShape!softmax_cross_entropy_with_logits*
T0*
out_type0*
_output_shapes
:
и
Bgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeReshapegradients/Mean_grad/truediv@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Shape*
T0*
Tshape0*#
_output_shapes
:€€€€€€€€€
Б
gradients/zeros_like	ZerosLike#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
К
?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dimConst*
dtype0*
_output_shapes
: *
valueB :
€€€€€€€€€
М
;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Reshape?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dim*

Tdim0*
T0*'
_output_shapes
:€€€€€€€€€
Ў
4gradients/softmax_cross_entropy_with_logits_grad/mulMul;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
ѓ
;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax
LogSoftmax)softmax_cross_entropy_with_logits/Reshape*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
≥
4gradients/softmax_cross_entropy_with_logits_grad/NegNeg;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax*
T0*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
М
Agradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dimConst*
valueB :
€€€€€€€€€*
dtype0*
_output_shapes
: 
Р
=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeAgradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dim*'
_output_shapes
:€€€€€€€€€*

Tdim0*
T0
н
6gradients/softmax_cross_entropy_with_logits_grad/mul_1Mul=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_14gradients/softmax_cross_entropy_with_logits_grad/Neg*0
_output_shapes
:€€€€€€€€€€€€€€€€€€*
T0
є
Agradients/softmax_cross_entropy_with_logits_grad/tuple/group_depsNoOp5^gradients/softmax_cross_entropy_with_logits_grad/mul7^gradients/softmax_cross_entropy_with_logits_grad/mul_1
”
Igradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependencyIdentity4gradients/softmax_cross_entropy_with_logits_grad/mulB^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*G
_class=
;9loc:@gradients/softmax_cross_entropy_with_logits_grad/mul*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
ў
Kgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency_1Identity6gradients/softmax_cross_entropy_with_logits_grad/mul_1B^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*I
_class?
=;loc:@gradients/softmax_cross_entropy_with_logits_grad/mul_1*0
_output_shapes
:€€€€€€€€€€€€€€€€€€
Г
>gradients/softmax_cross_entropy_with_logits/Reshape_grad/ShapeShapeAdd_3*
T0*
out_type0*
_output_shapes
:
Ц
@gradients/softmax_cross_entropy_with_logits/Reshape_grad/ReshapeReshapeIgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency>gradients/softmax_cross_entropy_with_logits/Reshape_grad/Shape*
T0*
Tshape0*'
_output_shapes
:€€€€€€€€€

b
gradients/Add_3_grad/ShapeShapeMatMul_3*
T0*
out_type0*
_output_shapes
:
f
gradients/Add_3_grad/Shape_1Const*
valueB:
*
dtype0*
_output_shapes
:
Ї
*gradients/Add_3_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_3_grad/Shapegradients/Add_3_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
Ќ
gradients/Add_3_grad/SumSum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape*gradients/Add_3_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 
Э
gradients/Add_3_grad/ReshapeReshapegradients/Add_3_grad/Sumgradients/Add_3_grad/Shape*
T0*
Tshape0*'
_output_shapes
:€€€€€€€€€

—
gradients/Add_3_grad/Sum_1Sum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape,gradients/Add_3_grad/BroadcastGradientArgs:1*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0
Ц
gradients/Add_3_grad/Reshape_1Reshapegradients/Add_3_grad/Sum_1gradients/Add_3_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:

m
%gradients/Add_3_grad/tuple/group_depsNoOp^gradients/Add_3_grad/Reshape^gradients/Add_3_grad/Reshape_1
в
-gradients/Add_3_grad/tuple/control_dependencyIdentitygradients/Add_3_grad/Reshape&^gradients/Add_3_grad/tuple/group_deps*'
_output_shapes
:€€€€€€€€€
*
T0*/
_class%
#!loc:@gradients/Add_3_grad/Reshape
џ
/gradients/Add_3_grad/tuple/control_dependency_1Identitygradients/Add_3_grad/Reshape_1&^gradients/Add_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_3_grad/Reshape_1*
_output_shapes
:

Ѕ
gradients/MatMul_3_grad/MatMulMatMul-gradients/Add_3_grad/tuple/control_dependencyout_weights/read*
transpose_a( *'
_output_shapes
:€€€€€€€€€ *
transpose_b(*
T0
≥
 gradients/MatMul_3_grad/MatMul_1MatMul	Sigmoid_2-gradients/Add_3_grad/tuple/control_dependency*
transpose_a(*
_output_shapes

: 
*
transpose_b( *
T0
t
(gradients/MatMul_3_grad/tuple/group_depsNoOp^gradients/MatMul_3_grad/MatMul!^gradients/MatMul_3_grad/MatMul_1
м
0gradients/MatMul_3_grad/tuple/control_dependencyIdentitygradients/MatMul_3_grad/MatMul)^gradients/MatMul_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_3_grad/MatMul*'
_output_shapes
:€€€€€€€€€ 
й
2gradients/MatMul_3_grad/tuple/control_dependency_1Identity gradients/MatMul_3_grad/MatMul_1)^gradients/MatMul_3_grad/tuple/group_deps*
_output_shapes

: 
*
T0*3
_class)
'%loc:@gradients/MatMul_3_grad/MatMul_1
Ґ
$gradients/Sigmoid_2_grad/SigmoidGradSigmoidGrad	Sigmoid_20gradients/MatMul_3_grad/tuple/control_dependency*
T0*'
_output_shapes
:€€€€€€€€€ 
b
gradients/Add_2_grad/ShapeShapeMatMul_2*
T0*
out_type0*
_output_shapes
:
f
gradients/Add_2_grad/Shape_1Const*
valueB: *
dtype0*
_output_shapes
:
Ї
*gradients/Add_2_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_2_grad/Shapegradients/Add_2_grad/Shape_1*
T0*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€
±
gradients/Add_2_grad/SumSum$gradients/Sigmoid_2_grad/SigmoidGrad*gradients/Add_2_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 
Э
gradients/Add_2_grad/ReshapeReshapegradients/Add_2_grad/Sumgradients/Add_2_grad/Shape*
T0*
Tshape0*'
_output_shapes
:€€€€€€€€€ 
µ
gradients/Add_2_grad/Sum_1Sum$gradients/Sigmoid_2_grad/SigmoidGrad,gradients/Add_2_grad/BroadcastGradientArgs:1*

Tidx0*
	keep_dims( *
T0*
_output_shapes
:
Ц
gradients/Add_2_grad/Reshape_1Reshapegradients/Add_2_grad/Sum_1gradients/Add_2_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
m
%gradients/Add_2_grad/tuple/group_depsNoOp^gradients/Add_2_grad/Reshape^gradients/Add_2_grad/Reshape_1
в
-gradients/Add_2_grad/tuple/control_dependencyIdentitygradients/Add_2_grad/Reshape&^gradients/Add_2_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_2_grad/Reshape*'
_output_shapes
:€€€€€€€€€ 
џ
/gradients/Add_2_grad/tuple/control_dependency_1Identitygradients/Add_2_grad/Reshape_1&^gradients/Add_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_2_grad/Reshape_1*
_output_shapes
: 
Ѕ
gradients/MatMul_2_grad/MatMulMatMul-gradients/Add_2_grad/tuple/control_dependencyl3_weights/read*
T0*
transpose_a( *(
_output_shapes
:€€€€€€€€€А*
transpose_b(
і
 gradients/MatMul_2_grad/MatMul_1MatMul	Sigmoid_1-gradients/Add_2_grad/tuple/control_dependency*
T0*
transpose_a(*
_output_shapes
:	А *
transpose_b( 
t
(gradients/MatMul_2_grad/tuple/group_depsNoOp^gradients/MatMul_2_grad/MatMul!^gradients/MatMul_2_grad/MatMul_1
н
0gradients/MatMul_2_grad/tuple/control_dependencyIdentitygradients/MatMul_2_grad/MatMul)^gradients/MatMul_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_2_grad/MatMul*(
_output_shapes
:€€€€€€€€€А
к
2gradients/MatMul_2_grad/tuple/control_dependency_1Identity gradients/MatMul_2_grad/MatMul_1)^gradients/MatMul_2_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_2_grad/MatMul_1*
_output_shapes
:	А 
£
$gradients/Sigmoid_1_grad/SigmoidGradSigmoidGrad	Sigmoid_10gradients/MatMul_2_grad/tuple/control_dependency*
T0*(
_output_shapes
:€€€€€€€€€А
b
gradients/Add_1_grad/ShapeShapeMatMul_1*
T0*
out_type0*
_output_shapes
:
g
gradients/Add_1_grad/Shape_1Const*
dtype0*
_output_shapes
:*
valueB:А
Ї
*gradients/Add_1_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_1_grad/Shapegradients/Add_1_grad/Shape_1*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€*
T0
±
gradients/Add_1_grad/SumSum$gradients/Sigmoid_1_grad/SigmoidGrad*gradients/Add_1_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 
Ю
gradients/Add_1_grad/ReshapeReshapegradients/Add_1_grad/Sumgradients/Add_1_grad/Shape*
T0*
Tshape0*(
_output_shapes
:€€€€€€€€€А
µ
gradients/Add_1_grad/Sum_1Sum$gradients/Sigmoid_1_grad/SigmoidGrad,gradients/Add_1_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 
Ч
gradients/Add_1_grad/Reshape_1Reshapegradients/Add_1_grad/Sum_1gradients/Add_1_grad/Shape_1*
_output_shapes	
:А*
T0*
Tshape0
m
%gradients/Add_1_grad/tuple/group_depsNoOp^gradients/Add_1_grad/Reshape^gradients/Add_1_grad/Reshape_1
г
-gradients/Add_1_grad/tuple/control_dependencyIdentitygradients/Add_1_grad/Reshape&^gradients/Add_1_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_1_grad/Reshape*(
_output_shapes
:€€€€€€€€€А
№
/gradients/Add_1_grad/tuple/control_dependency_1Identitygradients/Add_1_grad/Reshape_1&^gradients/Add_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_1_grad/Reshape_1*
_output_shapes	
:А
Ѕ
gradients/MatMul_1_grad/MatMulMatMul-gradients/Add_1_grad/tuple/control_dependencyl2_weights/read*
T0*
transpose_a( *(
_output_shapes
:€€€€€€€€€А*
transpose_b(
≥
 gradients/MatMul_1_grad/MatMul_1MatMulSigmoid-gradients/Add_1_grad/tuple/control_dependency*
transpose_b( *
T0*
transpose_a(* 
_output_shapes
:
АА
t
(gradients/MatMul_1_grad/tuple/group_depsNoOp^gradients/MatMul_1_grad/MatMul!^gradients/MatMul_1_grad/MatMul_1
н
0gradients/MatMul_1_grad/tuple/control_dependencyIdentitygradients/MatMul_1_grad/MatMul)^gradients/MatMul_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_1_grad/MatMul*(
_output_shapes
:€€€€€€€€€А
л
2gradients/MatMul_1_grad/tuple/control_dependency_1Identity gradients/MatMul_1_grad/MatMul_1)^gradients/MatMul_1_grad/tuple/group_deps* 
_output_shapes
:
АА*
T0*3
_class)
'%loc:@gradients/MatMul_1_grad/MatMul_1
Я
"gradients/Sigmoid_grad/SigmoidGradSigmoidGradSigmoid0gradients/MatMul_1_grad/tuple/control_dependency*(
_output_shapes
:€€€€€€€€€А*
T0
^
gradients/Add_grad/ShapeShapeMatMul*
T0*
out_type0*
_output_shapes
:
e
gradients/Add_grad/Shape_1Const*
valueB:А*
dtype0*
_output_shapes
:
і
(gradients/Add_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_grad/Shapegradients/Add_grad/Shape_1*2
_output_shapes 
:€€€€€€€€€:€€€€€€€€€*
T0
Ђ
gradients/Add_grad/SumSum"gradients/Sigmoid_grad/SigmoidGrad(gradients/Add_grad/BroadcastGradientArgs*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0
Ш
gradients/Add_grad/ReshapeReshapegradients/Add_grad/Sumgradients/Add_grad/Shape*
T0*
Tshape0*(
_output_shapes
:€€€€€€€€€А
ѓ
gradients/Add_grad/Sum_1Sum"gradients/Sigmoid_grad/SigmoidGrad*gradients/Add_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 
С
gradients/Add_grad/Reshape_1Reshapegradients/Add_grad/Sum_1gradients/Add_grad/Shape_1*
T0*
Tshape0*
_output_shapes	
:А
g
#gradients/Add_grad/tuple/group_depsNoOp^gradients/Add_grad/Reshape^gradients/Add_grad/Reshape_1
џ
+gradients/Add_grad/tuple/control_dependencyIdentitygradients/Add_grad/Reshape$^gradients/Add_grad/tuple/group_deps*(
_output_shapes
:€€€€€€€€€А*
T0*-
_class#
!loc:@gradients/Add_grad/Reshape
‘
-gradients/Add_grad/tuple/control_dependency_1Identitygradients/Add_grad/Reshape_1$^gradients/Add_grad/tuple/group_deps*
_output_shapes	
:А*
T0*/
_class%
#!loc:@gradients/Add_grad/Reshape_1
љ
gradients/MatMul_grad/MatMulMatMul+gradients/Add_grad/tuple/control_dependencyl1_weights/read*
T0*
transpose_a( *(
_output_shapes
:€€€€€€€€€Р*
transpose_b(
≥
gradients/MatMul_grad/MatMul_1MatMulPlaceholder+gradients/Add_grad/tuple/control_dependency*
T0*
transpose_a(* 
_output_shapes
:
РА*
transpose_b( 
n
&gradients/MatMul_grad/tuple/group_depsNoOp^gradients/MatMul_grad/MatMul^gradients/MatMul_grad/MatMul_1
е
.gradients/MatMul_grad/tuple/control_dependencyIdentitygradients/MatMul_grad/MatMul'^gradients/MatMul_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/MatMul_grad/MatMul*(
_output_shapes
:€€€€€€€€€Р
г
0gradients/MatMul_grad/tuple/control_dependency_1Identitygradients/MatMul_grad/MatMul_1'^gradients/MatMul_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_grad/MatMul_1* 
_output_shapes
:
РА
z
beta1_power/initial_valueConst*
_class
loc:@l1_bias*
valueB
 *fff?*
dtype0*
_output_shapes
: 
Л
beta1_power
VariableV2*
_class
loc:@l1_bias*
	container *
shape: *
dtype0*
_output_shapes
: *
shared_name 
™
beta1_power/AssignAssignbeta1_powerbeta1_power/initial_value*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
f
beta1_power/readIdentitybeta1_power*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
z
beta2_power/initial_valueConst*
_class
loc:@l1_bias*
valueB
 *wЊ?*
dtype0*
_output_shapes
: 
Л
beta2_power
VariableV2*
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l1_bias*
	container *
shape: 
™
beta2_power/AssignAssignbeta2_powerbeta2_power/initial_value*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
f
beta2_power/readIdentitybeta2_power*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
°
1l1_weights/Adam/Initializer/zeros/shape_as_tensorConst*
valueB"     *
_class
loc:@l1_weights*
dtype0*
_output_shapes
:
Л
'l1_weights/Adam/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l1_weights*
dtype0*
_output_shapes
: 
б
!l1_weights/Adam/Initializer/zerosFill1l1_weights/Adam/Initializer/zeros/shape_as_tensor'l1_weights/Adam/Initializer/zeros/Const* 
_output_shapes
:
РА*
T0*

index_type0*
_class
loc:@l1_weights
¶
l1_weights/Adam
VariableV2*
dtype0* 
_output_shapes
:
РА*
shared_name *
_class
loc:@l1_weights*
	container *
shape:
РА
«
l1_weights/Adam/AssignAssignl1_weights/Adam!l1_weights/Adam/Initializer/zeros*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights
{
l1_weights/Adam/readIdentityl1_weights/Adam*
T0*
_class
loc:@l1_weights* 
_output_shapes
:
РА
£
3l1_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
valueB"     *
_class
loc:@l1_weights*
dtype0*
_output_shapes
:
Н
)l1_weights/Adam_1/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l1_weights*
dtype0*
_output_shapes
: 
з
#l1_weights/Adam_1/Initializer/zerosFill3l1_weights/Adam_1/Initializer/zeros/shape_as_tensor)l1_weights/Adam_1/Initializer/zeros/Const* 
_output_shapes
:
РА*
T0*

index_type0*
_class
loc:@l1_weights
®
l1_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@l1_weights*
	container *
shape:
РА*
dtype0* 
_output_shapes
:
РА
Ќ
l1_weights/Adam_1/AssignAssignl1_weights/Adam_1#l1_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА

l1_weights/Adam_1/readIdentityl1_weights/Adam_1*
T0*
_class
loc:@l1_weights* 
_output_shapes
:
РА
Й
l1_bias/Adam/Initializer/zerosConst*
valueBА*    *
_class
loc:@l1_bias*
dtype0*
_output_shapes	
:А
Ц
l1_bias/Adam
VariableV2*
dtype0*
_output_shapes	
:А*
shared_name *
_class
loc:@l1_bias*
	container *
shape:А
ґ
l1_bias/Adam/AssignAssignl1_bias/Adaml1_bias/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А
m
l1_bias/Adam/readIdentityl1_bias/Adam*
T0*
_class
loc:@l1_bias*
_output_shapes	
:А
Л
 l1_bias/Adam_1/Initializer/zerosConst*
valueBА*    *
_class
loc:@l1_bias*
dtype0*
_output_shapes	
:А
Ш
l1_bias/Adam_1
VariableV2*
	container *
shape:А*
dtype0*
_output_shapes	
:А*
shared_name *
_class
loc:@l1_bias
Љ
l1_bias/Adam_1/AssignAssignl1_bias/Adam_1 l1_bias/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А
q
l1_bias/Adam_1/readIdentityl1_bias/Adam_1*
T0*
_class
loc:@l1_bias*
_output_shapes	
:А
°
1l2_weights/Adam/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
valueB"   А   *
_class
loc:@l2_weights
Л
'l2_weights/Adam/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l2_weights*
dtype0*
_output_shapes
: 
б
!l2_weights/Adam/Initializer/zerosFill1l2_weights/Adam/Initializer/zeros/shape_as_tensor'l2_weights/Adam/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l2_weights* 
_output_shapes
:
АА
¶
l2_weights/Adam
VariableV2*
	container *
shape:
АА*
dtype0* 
_output_shapes
:
АА*
shared_name *
_class
loc:@l2_weights
«
l2_weights/Adam/AssignAssignl2_weights/Adam!l2_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
{
l2_weights/Adam/readIdentityl2_weights/Adam*
T0*
_class
loc:@l2_weights* 
_output_shapes
:
АА
£
3l2_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
valueB"   А   *
_class
loc:@l2_weights
Н
)l2_weights/Adam_1/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l2_weights*
dtype0*
_output_shapes
: 
з
#l2_weights/Adam_1/Initializer/zerosFill3l2_weights/Adam_1/Initializer/zeros/shape_as_tensor)l2_weights/Adam_1/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l2_weights* 
_output_shapes
:
АА
®
l2_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@l2_weights*
	container *
shape:
АА*
dtype0* 
_output_shapes
:
АА
Ќ
l2_weights/Adam_1/AssignAssignl2_weights/Adam_1#l2_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА

l2_weights/Adam_1/readIdentityl2_weights/Adam_1* 
_output_shapes
:
АА*
T0*
_class
loc:@l2_weights
Й
l2_bias/Adam/Initializer/zerosConst*
dtype0*
_output_shapes	
:А*
valueBА*    *
_class
loc:@l2_bias
Ц
l2_bias/Adam
VariableV2*
shared_name *
_class
loc:@l2_bias*
	container *
shape:А*
dtype0*
_output_shapes	
:А
ґ
l2_bias/Adam/AssignAssignl2_bias/Adaml2_bias/Adam/Initializer/zeros*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
m
l2_bias/Adam/readIdentityl2_bias/Adam*
T0*
_class
loc:@l2_bias*
_output_shapes	
:А
Л
 l2_bias/Adam_1/Initializer/zerosConst*
dtype0*
_output_shapes	
:А*
valueBА*    *
_class
loc:@l2_bias
Ш
l2_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@l2_bias*
	container *
shape:А*
dtype0*
_output_shapes	
:А
Љ
l2_bias/Adam_1/AssignAssignl2_bias/Adam_1 l2_bias/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А
q
l2_bias/Adam_1/readIdentityl2_bias/Adam_1*
_output_shapes	
:А*
T0*
_class
loc:@l2_bias
°
1l3_weights/Adam/Initializer/zeros/shape_as_tensorConst*
valueB"А       *
_class
loc:@l3_weights*
dtype0*
_output_shapes
:
Л
'l3_weights/Adam/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
valueB
 *    *
_class
loc:@l3_weights
а
!l3_weights/Adam/Initializer/zerosFill1l3_weights/Adam/Initializer/zeros/shape_as_tensor'l3_weights/Adam/Initializer/zeros/Const*
_output_shapes
:	А *
T0*

index_type0*
_class
loc:@l3_weights
§
l3_weights/Adam
VariableV2*
shape:	А *
dtype0*
_output_shapes
:	А *
shared_name *
_class
loc:@l3_weights*
	container 
∆
l3_weights/Adam/AssignAssignl3_weights/Adam!l3_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А 
z
l3_weights/Adam/readIdentityl3_weights/Adam*
T0*
_class
loc:@l3_weights*
_output_shapes
:	А 
£
3l3_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
valueB"А       *
_class
loc:@l3_weights
Н
)l3_weights/Adam_1/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l3_weights*
dtype0*
_output_shapes
: 
ж
#l3_weights/Adam_1/Initializer/zerosFill3l3_weights/Adam_1/Initializer/zeros/shape_as_tensor)l3_weights/Adam_1/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l3_weights*
_output_shapes
:	А 
¶
l3_weights/Adam_1
VariableV2*
shape:	А *
dtype0*
_output_shapes
:	А *
shared_name *
_class
loc:@l3_weights*
	container 
ћ
l3_weights/Adam_1/AssignAssignl3_weights/Adam_1#l3_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А 
~
l3_weights/Adam_1/readIdentityl3_weights/Adam_1*
T0*
_class
loc:@l3_weights*
_output_shapes
:	А 
З
l3_bias/Adam/Initializer/zerosConst*
dtype0*
_output_shapes
: *
valueB *    *
_class
loc:@l3_bias
Ф
l3_bias/Adam
VariableV2*
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l3_bias*
	container *
shape: 
µ
l3_bias/Adam/AssignAssignl3_bias/Adaml3_bias/Adam/Initializer/zeros*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
l
l3_bias/Adam/readIdentityl3_bias/Adam*
T0*
_class
loc:@l3_bias*
_output_shapes
: 
Й
 l3_bias/Adam_1/Initializer/zerosConst*
valueB *    *
_class
loc:@l3_bias*
dtype0*
_output_shapes
: 
Ц
l3_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@l3_bias*
	container *
shape: *
dtype0*
_output_shapes
: 
ї
l3_bias/Adam_1/AssignAssignl3_bias/Adam_1 l3_bias/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
p
l3_bias/Adam_1/readIdentityl3_bias/Adam_1*
_output_shapes
: *
T0*
_class
loc:@l3_bias
Ч
"out_weights/Adam/Initializer/zerosConst*
valueB 
*    *
_class
loc:@out_weights*
dtype0*
_output_shapes

: 

§
out_weights/Adam
VariableV2*
dtype0*
_output_shapes

: 
*
shared_name *
_class
loc:@out_weights*
	container *
shape
: 

…
out_weights/Adam/AssignAssignout_weights/Adam"out_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

|
out_weights/Adam/readIdentityout_weights/Adam*
_output_shapes

: 
*
T0*
_class
loc:@out_weights
Щ
$out_weights/Adam_1/Initializer/zerosConst*
valueB 
*    *
_class
loc:@out_weights*
dtype0*
_output_shapes

: 

¶
out_weights/Adam_1
VariableV2*
shape
: 
*
dtype0*
_output_shapes

: 
*
shared_name *
_class
loc:@out_weights*
	container 
ѕ
out_weights/Adam_1/AssignAssignout_weights/Adam_1$out_weights/Adam_1/Initializer/zeros*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
А
out_weights/Adam_1/readIdentityout_weights/Adam_1*
T0*
_class
loc:@out_weights*
_output_shapes

: 

Й
out_bias/Adam/Initializer/zerosConst*
valueB
*    *
_class
loc:@out_bias*
dtype0*
_output_shapes
:

Ц
out_bias/Adam
VariableV2*
shape:
*
dtype0*
_output_shapes
:
*
shared_name *
_class
loc:@out_bias*
	container 
є
out_bias/Adam/AssignAssignout_bias/Adamout_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
o
out_bias/Adam/readIdentityout_bias/Adam*
T0*
_class
loc:@out_bias*
_output_shapes
:

Л
!out_bias/Adam_1/Initializer/zerosConst*
valueB
*    *
_class
loc:@out_bias*
dtype0*
_output_shapes
:

Ш
out_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@out_bias*
	container *
shape:
*
dtype0*
_output_shapes
:

њ
out_bias/Adam_1/AssignAssignout_bias/Adam_1!out_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
s
out_bias/Adam_1/readIdentityout_bias/Adam_1*
T0*
_class
loc:@out_bias*
_output_shapes
:

W
Adam/learning_rateConst*
valueB
 *oГ:*
dtype0*
_output_shapes
: 
O

Adam/beta1Const*
dtype0*
_output_shapes
: *
valueB
 *fff?
O

Adam/beta2Const*
valueB
 *wЊ?*
dtype0*
_output_shapes
: 
Q
Adam/epsilonConst*
valueB
 *wћ+2*
dtype0*
_output_shapes
: 
ё
 Adam/update_l1_weights/ApplyAdam	ApplyAdam
l1_weightsl1_weights/Adaml1_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon0gradients/MatMul_grad/tuple/control_dependency_1*
T0*
_class
loc:@l1_weights*
use_nesterov( * 
_output_shapes
:
РА*
use_locking( 
«
Adam/update_l1_bias/ApplyAdam	ApplyAdaml1_biasl1_bias/Adaml1_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon-gradients/Add_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l1_bias*
use_nesterov( *
_output_shapes	
:А
а
 Adam/update_l2_weights/ApplyAdam	ApplyAdam
l2_weightsl2_weights/Adaml2_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_1_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l2_weights*
use_nesterov( * 
_output_shapes
:
АА
…
Adam/update_l2_bias/ApplyAdam	ApplyAdaml2_biasl2_bias/Adaml2_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_1_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l2_bias*
use_nesterov( *
_output_shapes	
:А
я
 Adam/update_l3_weights/ApplyAdam	ApplyAdam
l3_weightsl3_weights/Adaml3_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_2_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l3_weights*
use_nesterov( *
_output_shapes
:	А 
»
Adam/update_l3_bias/ApplyAdam	ApplyAdaml3_biasl3_bias/Adaml3_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_2_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l3_bias*
use_nesterov( *
_output_shapes
: 
г
!Adam/update_out_weights/ApplyAdam	ApplyAdamout_weightsout_weights/Adamout_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_3_grad/tuple/control_dependency_1*
T0*
_class
loc:@out_weights*
use_nesterov( *
_output_shapes

: 
*
use_locking( 
Ќ
Adam/update_out_bias/ApplyAdam	ApplyAdamout_biasout_bias/Adamout_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_3_grad/tuple/control_dependency_1*
use_nesterov( *
_output_shapes
:
*
use_locking( *
T0*
_class
loc:@out_bias
ш
Adam/mulMulbeta1_power/read
Adam/beta1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
Т
Adam/AssignAssignbeta1_powerAdam/mul*
use_locking( *
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
ъ

Adam/mul_1Mulbeta2_power/read
Adam/beta2^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
Ц
Adam/Assign_1Assignbeta2_power
Adam/mul_1*
use_locking( *
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
Є
AdamNoOp^Adam/Assign^Adam/Assign_1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam
Ў
initNoOp^beta1_power/Assign^beta2_power/Assign^l1_bias/Adam/Assign^l1_bias/Adam_1/Assign^l1_bias/Assign^l1_weights/Adam/Assign^l1_weights/Adam_1/Assign^l1_weights/Assign^l2_bias/Adam/Assign^l2_bias/Adam_1/Assign^l2_bias/Assign^l2_weights/Adam/Assign^l2_weights/Adam_1/Assign^l2_weights/Assign^l3_bias/Adam/Assign^l3_bias/Adam_1/Assign^l3_bias/Assign^l3_weights/Adam/Assign^l3_weights/Adam_1/Assign^l3_weights/Assign^out_bias/Adam/Assign^out_bias/Adam_1/Assign^out_bias/Assign^out_weights/Adam/Assign^out_weights/Adam_1/Assign^out_weights/Assign
R
ArgMax/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
v
ArgMaxArgMaxAdd_3ArgMax/dimension*
output_type0	*#
_output_shapes
:€€€€€€€€€*

Tidx0*
T0
T
ArgMax_1/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
w
ArgMax_1ArgMaxPlaceholder_1ArgMax_1/dimension*
T0*
output_type0	*
_output_shapes
:*

Tidx0
C
EqualEqualArgMaxArgMax_1*
T0	*
_output_shapes
:
U
CastCastEqual*
Truncate( *

DstT0*
_output_shapes
:*

SrcT0

3
RankRankCast*
_output_shapes
: *
T0
M
range/startConst*
value	B : *
dtype0*
_output_shapes
: 
M
range/deltaConst*
value	B :*
dtype0*
_output_shapes
: 
_
rangeRangerange/startRankrange/delta*

Tidx0*#
_output_shapes
:€€€€€€€€€
Y
Mean_1MeanCastrange*
T0*
_output_shapes
: *

Tidx0*
	keep_dims( 
Y
save/filename/inputConst*
valueB Bmodel*
dtype0*
_output_shapes
: 
n
save/filenamePlaceholderWithDefaultsave/filename/input*
dtype0*
_output_shapes
: *
shape: 
e

save/ConstPlaceholderWithDefaultsave/filename*
dtype0*
_output_shapes
: *
shape: 
ё
save/SaveV2/tensor_namesConst*С
valueЗBДBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:
Ч
save/SaveV2/shape_and_slicesConst*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B *
dtype0*
_output_shapes
:
€
save/SaveV2SaveV2
save/Constsave/SaveV2/tensor_namessave/SaveV2/shape_and_slicesbeta1_powerbeta2_powerl1_biasl1_bias/Adaml1_bias/Adam_1
l1_weightsl1_weights/Adaml1_weights/Adam_1l2_biasl2_bias/Adaml2_bias/Adam_1
l2_weightsl2_weights/Adaml2_weights/Adam_1l3_biasl3_bias/Adaml3_bias/Adam_1
l3_weightsl3_weights/Adaml3_weights/Adam_1out_biasout_bias/Adamout_bias/Adam_1out_weightsout_weights/Adamout_weights/Adam_1*(
dtypes
2
}
save/control_dependencyIdentity
save/Const^save/SaveV2*
_output_shapes
: *
T0*
_class
loc:@save/Const
р
save/RestoreV2/tensor_namesConst"/device:CPU:0*С
valueЗBДBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:
©
save/RestoreV2/shape_and_slicesConst"/device:CPU:0*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B *
dtype0*
_output_shapes
:
Ь
save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*|
_output_shapesj
h::::::::::::::::::::::::::*(
dtypes
2
Ш
save/AssignAssignbeta1_powersave/RestoreV2*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: *
use_locking(
Ь
save/Assign_1Assignbeta2_powersave/RestoreV2:1*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l1_bias
Э
save/Assign_2Assignl1_biassave/RestoreV2:2*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
Ґ
save/Assign_3Assignl1_bias/Adamsave/RestoreV2:3*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:А*
use_locking(
§
save/Assign_4Assignl1_bias/Adam_1save/RestoreV2:4*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l1_bias
®
save/Assign_5Assign
l1_weightssave/RestoreV2:5*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
РА
≠
save/Assign_6Assignl1_weights/Adamsave/RestoreV2:6*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights
ѓ
save/Assign_7Assignl1_weights/Adam_1save/RestoreV2:7*
validate_shape(* 
_output_shapes
:
РА*
use_locking(*
T0*
_class
loc:@l1_weights
Э
save/Assign_8Assignl2_biassave/RestoreV2:8*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А
Ґ
save/Assign_9Assignl2_bias/Adamsave/RestoreV2:9*
validate_shape(*
_output_shapes	
:А*
use_locking(*
T0*
_class
loc:@l2_bias
¶
save/Assign_10Assignl2_bias/Adam_1save/RestoreV2:10*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes	
:А
™
save/Assign_11Assign
l2_weightssave/RestoreV2:11*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА*
use_locking(
ѓ
save/Assign_12Assignl2_weights/Adamsave/RestoreV2:12*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
±
save/Assign_13Assignl2_weights/Adam_1save/RestoreV2:13*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(* 
_output_shapes
:
АА
Ю
save/Assign_14Assignl3_biassave/RestoreV2:14*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
£
save/Assign_15Assignl3_bias/Adamsave/RestoreV2:15*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
•
save/Assign_16Assignl3_bias/Adam_1save/RestoreV2:16*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
©
save/Assign_17Assign
l3_weightssave/RestoreV2:17*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
Ѓ
save/Assign_18Assignl3_weights/Adamsave/RestoreV2:18*
validate_shape(*
_output_shapes
:	А *
use_locking(*
T0*
_class
loc:@l3_weights
∞
save/Assign_19Assignl3_weights/Adam_1save/RestoreV2:19*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes
:	А 
†
save/Assign_20Assignout_biassave/RestoreV2:20*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

•
save/Assign_21Assignout_bias/Adamsave/RestoreV2:21*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

І
save/Assign_22Assignout_bias/Adam_1save/RestoreV2:22*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

™
save/Assign_23Assignout_weightssave/RestoreV2:23*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

ѓ
save/Assign_24Assignout_weights/Adamsave/RestoreV2:24*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

±
save/Assign_25Assignout_weights/Adam_1save/RestoreV2:25*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

∆
save/restore_allNoOp^save/Assign^save/Assign_1^save/Assign_10^save/Assign_11^save/Assign_12^save/Assign_13^save/Assign_14^save/Assign_15^save/Assign_16^save/Assign_17^save/Assign_18^save/Assign_19^save/Assign_2^save/Assign_20^save/Assign_21^save/Assign_22^save/Assign_23^save/Assign_24^save/Assign_25^save/Assign_3^save/Assign_4^save/Assign_5^save/Assign_6^save/Assign_7^save/Assign_8^save/Assign_9"&"
train_op

Adam"Е
	variablesчф
G
l1_weights:0l1_weights/Assignl1_weights/read:02random_normal:08
@
	l1_bias:0l1_bias/Assignl1_bias/read:02random_normal_1:08
I
l2_weights:0l2_weights/Assignl2_weights/read:02random_normal_2:08
@
	l2_bias:0l2_bias/Assignl2_bias/read:02random_normal_3:08
I
l3_weights:0l3_weights/Assignl3_weights/read:02random_normal_4:08
@
	l3_bias:0l3_bias/Assignl3_bias/read:02random_normal_5:08
L
out_weights:0out_weights/Assignout_weights/read:02random_normal_6:08
C

out_bias:0out_bias/Assignout_bias/read:02random_normal_7:08
T
beta1_power:0beta1_power/Assignbeta1_power/read:02beta1_power/initial_value:0
T
beta2_power:0beta2_power/Assignbeta2_power/read:02beta2_power/initial_value:0
h
l1_weights/Adam:0l1_weights/Adam/Assignl1_weights/Adam/read:02#l1_weights/Adam/Initializer/zeros:0
p
l1_weights/Adam_1:0l1_weights/Adam_1/Assignl1_weights/Adam_1/read:02%l1_weights/Adam_1/Initializer/zeros:0
\
l1_bias/Adam:0l1_bias/Adam/Assignl1_bias/Adam/read:02 l1_bias/Adam/Initializer/zeros:0
d
l1_bias/Adam_1:0l1_bias/Adam_1/Assignl1_bias/Adam_1/read:02"l1_bias/Adam_1/Initializer/zeros:0
h
l2_weights/Adam:0l2_weights/Adam/Assignl2_weights/Adam/read:02#l2_weights/Adam/Initializer/zeros:0
p
l2_weights/Adam_1:0l2_weights/Adam_1/Assignl2_weights/Adam_1/read:02%l2_weights/Adam_1/Initializer/zeros:0
\
l2_bias/Adam:0l2_bias/Adam/Assignl2_bias/Adam/read:02 l2_bias/Adam/Initializer/zeros:0
d
l2_bias/Adam_1:0l2_bias/Adam_1/Assignl2_bias/Adam_1/read:02"l2_bias/Adam_1/Initializer/zeros:0
h
l3_weights/Adam:0l3_weights/Adam/Assignl3_weights/Adam/read:02#l3_weights/Adam/Initializer/zeros:0
p
l3_weights/Adam_1:0l3_weights/Adam_1/Assignl3_weights/Adam_1/read:02%l3_weights/Adam_1/Initializer/zeros:0
\
l3_bias/Adam:0l3_bias/Adam/Assignl3_bias/Adam/read:02 l3_bias/Adam/Initializer/zeros:0
d
l3_bias/Adam_1:0l3_bias/Adam_1/Assignl3_bias/Adam_1/read:02"l3_bias/Adam_1/Initializer/zeros:0
l
out_weights/Adam:0out_weights/Adam/Assignout_weights/Adam/read:02$out_weights/Adam/Initializer/zeros:0
t
out_weights/Adam_1:0out_weights/Adam_1/Assignout_weights/Adam_1/read:02&out_weights/Adam_1/Initializer/zeros:0
`
out_bias/Adam:0out_bias/Adam/Assignout_bias/Adam/read:02!out_bias/Adam/Initializer/zeros:0
h
out_bias/Adam_1:0out_bias/Adam_1/Assignout_bias/Adam_1/read:02#out_bias/Adam_1/Initializer/zeros:0"”
trainable_variablesїЄ
G
l1_weights:0l1_weights/Assignl1_weights/read:02random_normal:08
@
	l1_bias:0l1_bias/Assignl1_bias/read:02random_normal_1:08
I
l2_weights:0l2_weights/Assignl2_weights/read:02random_normal_2:08
@
	l2_bias:0l2_bias/Assignl2_bias/read:02random_normal_3:08
I
l3_weights:0l3_weights/Assignl3_weights/read:02random_normal_4:08
@
	l3_bias:0l3_bias/Assignl3_bias/read:02random_normal_5:08
L
out_weights:0out_weights/Assignout_weights/read:02random_normal_6:08
C

out_bias:0out_bias/Assignout_bias/read:02random_normal_7:08ZР-