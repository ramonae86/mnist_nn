       ЃK"	   "&зAbrain.Event:2иж_ф      жЗ	ER
"&зA"Ш
p
PlaceholderPlaceholder*
dtype0*(
_output_shapes
:џџџџџџџџџ*
shape:џџџџџџџџџ
R
Placeholder_1Placeholder*
dtype0*
_output_shapes
:*
shape:
d
random_normal/shapeConst*
valueB"     *
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
 *  ?*
dtype0*
_output_shapes
: 
 
"random_normal/RandomStandardNormalRandomStandardNormalrandom_normal/shape*

seed *
T0*
dtype0* 
_output_shapes
:
*
seed2 
}
random_normal/mulMul"random_normal/RandomStandardNormalrandom_normal/stddev*
T0* 
_output_shapes
:

f
random_normalAddrandom_normal/mulrandom_normal/mean* 
_output_shapes
:
*
T0


l1_weights
VariableV2*
shared_name *
dtype0* 
_output_shapes
:
*
	container *
shape:

Љ
l1_weights/AssignAssign
l1_weightsrandom_normal*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
*
use_locking(
q
l1_weights/readIdentity
l1_weights*
T0*
_class
loc:@l1_weights* 
_output_shapes
:

`
random_normal_1/shapeConst*
dtype0*
_output_shapes
:*
valueB:
Y
random_normal_1/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_1/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  ?

$random_normal_1/RandomStandardNormalRandomStandardNormalrandom_normal_1/shape*
T0*
dtype0*
_output_shapes	
:*
seed2 *

seed 
~
random_normal_1/mulMul$random_normal_1/RandomStandardNormalrandom_normal_1/stddev*
_output_shapes	
:*
T0
g
random_normal_1Addrandom_normal_1/mulrandom_normal_1/mean*
T0*
_output_shapes	
:
u
l1_bias
VariableV2*
shared_name *
dtype0*
_output_shapes	
:*
	container *
shape:

l1_bias/AssignAssignl1_biasrandom_normal_1*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:*
use_locking(
c
l1_bias/readIdentityl1_bias*
T0*
_class
loc:@l1_bias*
_output_shapes	
:
f
random_normal_2/shapeConst*
valueB"   @   *
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
random_normal_2/stddevConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 
Ѓ
$random_normal_2/RandomStandardNormalRandomStandardNormalrandom_normal_2/shape*

seed *
T0*
dtype0*
_output_shapes
:	@*
seed2 

random_normal_2/mulMul$random_normal_2/RandomStandardNormalrandom_normal_2/stddev*
T0*
_output_shapes
:	@
k
random_normal_2Addrandom_normal_2/mulrandom_normal_2/mean*
_output_shapes
:	@*
T0


l2_weights
VariableV2*
dtype0*
_output_shapes
:	@*
	container *
shape:	@*
shared_name 
Њ
l2_weights/AssignAssign
l2_weightsrandom_normal_2*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@*
use_locking(
p
l2_weights/readIdentity
l2_weights*
_output_shapes
:	@*
T0*
_class
loc:@l2_weights
_
random_normal_3/shapeConst*
valueB:@*
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
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_3/RandomStandardNormalRandomStandardNormalrandom_normal_3/shape*
T0*
dtype0*
_output_shapes
:@*
seed2 *

seed 
}
random_normal_3/mulMul$random_normal_3/RandomStandardNormalrandom_normal_3/stddev*
_output_shapes
:@*
T0
f
random_normal_3Addrandom_normal_3/mulrandom_normal_3/mean*
T0*
_output_shapes
:@
s
l2_bias
VariableV2*
shared_name *
dtype0*
_output_shapes
:@*
	container *
shape:@

l2_bias/AssignAssignl2_biasrandom_normal_3*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
b
l2_bias/readIdentityl2_bias*
_output_shapes
:@*
T0*
_class
loc:@l2_bias
f
random_normal_4/shapeConst*
valueB"@       *
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
 *  ?*
dtype0*
_output_shapes
: 
Ђ
$random_normal_4/RandomStandardNormalRandomStandardNormalrandom_normal_4/shape*
T0*
dtype0*
_output_shapes

:@ *
seed2 *

seed 

random_normal_4/mulMul$random_normal_4/RandomStandardNormalrandom_normal_4/stddev*
T0*
_output_shapes

:@ 
j
random_normal_4Addrandom_normal_4/mulrandom_normal_4/mean*
T0*
_output_shapes

:@ 
~

l3_weights
VariableV2*
dtype0*
_output_shapes

:@ *
	container *
shape
:@ *
shared_name 
Љ
l3_weights/AssignAssign
l3_weightsrandom_normal_4*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ *
use_locking(
o
l3_weights/readIdentity
l3_weights*
_output_shapes

:@ *
T0*
_class
loc:@l3_weights
_
random_normal_5/shapeConst*
valueB: *
dtype0*
_output_shapes
:
Y
random_normal_5/meanConst*
dtype0*
_output_shapes
: *
valueB
 *    
[
random_normal_5/stddevConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_5/RandomStandardNormalRandomStandardNormalrandom_normal_5/shape*
T0*
dtype0*
_output_shapes
: *
seed2 *

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
VariableV2*
dtype0*
_output_shapes
: *
	container *
shape: *
shared_name 

l3_bias/AssignAssignl3_biasrandom_normal_5*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
b
l3_bias/readIdentityl3_bias*
T0*
_class
loc:@l3_bias*
_output_shapes
: 
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
 *  ?*
dtype0*
_output_shapes
: 
Ђ
$random_normal_6/RandomStandardNormalRandomStandardNormalrandom_normal_6/shape*
dtype0*
_output_shapes

: 
*
seed2 *

seed *
T0

random_normal_6/mulMul$random_normal_6/RandomStandardNormalrandom_normal_6/stddev*
_output_shapes

: 
*
T0
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
dtype0*
_output_shapes

: 
*
	container *
shape
: 

Ќ
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
random_normal_7/stddevConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_7/RandomStandardNormalRandomStandardNormalrandom_normal_7/shape*
T0*
dtype0*
_output_shapes
:
*
seed2 *

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
VariableV2*
dtype0*
_output_shapes
:
*
	container *
shape:
*
shared_name 

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

MatMulMatMulPlaceholderl1_weights/read*(
_output_shapes
:џџџџџџџџџ*
transpose_a( *
transpose_b( *
T0
S
AddAddMatMull1_bias/read*(
_output_shapes
:џџџџџџџџџ*
T0
J
SigmoidSigmoidAdd*
T0*(
_output_shapes
:џџџџџџџџџ

MatMul_1MatMulSigmoidl2_weights/read*
T0*'
_output_shapes
:џџџџџџџџџ@*
transpose_a( *
transpose_b( 
V
Add_1AddMatMul_1l2_bias/read*'
_output_shapes
:џџџџџџџџџ@*
T0
M
	Sigmoid_1SigmoidAdd_1*'
_output_shapes
:џџџџџџџџџ@*
T0

MatMul_2MatMul	Sigmoid_1l3_weights/read*
T0*'
_output_shapes
:џџџџџџџџџ *
transpose_a( *
transpose_b( 
V
Add_2AddMatMul_2l3_bias/read*
T0*'
_output_shapes
:џџџџџџџџџ 
M
	Sigmoid_2SigmoidAdd_2*'
_output_shapes
:џџџџџџџџџ *
T0

MatMul_3MatMul	Sigmoid_2out_weights/read*
T0*'
_output_shapes
:џџџџџџџџџ
*
transpose_a( *
transpose_b( 
W
Add_3AddMatMul_3out_bias/read*
T0*'
_output_shapes
:џџџџџџџџџ

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
 
%softmax_cross_entropy_with_logits/SubSub(softmax_cross_entropy_with_logits/Rank_1'softmax_cross_entropy_with_logits/Sub/y*
T0*
_output_shapes
: 

-softmax_cross_entropy_with_logits/Slice/beginPack%softmax_cross_entropy_with_logits/Sub*
T0*

axis *
N*
_output_shapes
:
v
,softmax_cross_entropy_with_logits/Slice/sizeConst*
valueB:*
dtype0*
_output_shapes
:
ъ
'softmax_cross_entropy_with_logits/SliceSlice)softmax_cross_entropy_with_logits/Shape_1-softmax_cross_entropy_with_logits/Slice/begin,softmax_cross_entropy_with_logits/Slice/size*
Index0*
T0*
_output_shapes
:

1softmax_cross_entropy_with_logits/concat/values_0Const*
valueB:
џџџџџџџџџ*
dtype0*
_output_shapes
:
o
-softmax_cross_entropy_with_logits/concat/axisConst*
value	B : *
dtype0*
_output_shapes
: 
љ
(softmax_cross_entropy_with_logits/concatConcatV21softmax_cross_entropy_with_logits/concat/values_0'softmax_cross_entropy_with_logits/Slice-softmax_cross_entropy_with_logits/concat/axis*
T0*
N*
_output_shapes
:*

Tidx0
Ў
)softmax_cross_entropy_with_logits/ReshapeReshapeAdd_3(softmax_cross_entropy_with_logits/concat*
T0*
Tshape0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
`
(softmax_cross_entropy_with_logits/Rank_2RankPlaceholder_1*
_output_shapes
: *
T0

)softmax_cross_entropy_with_logits/Shape_2ShapePlaceholder_1*
T0*
out_type0*#
_output_shapes
:џџџџџџџџџ
k
)softmax_cross_entropy_with_logits/Sub_1/yConst*
value	B :*
dtype0*
_output_shapes
: 
Є
'softmax_cross_entropy_with_logits/Sub_1Sub(softmax_cross_entropy_with_logits/Rank_2)softmax_cross_entropy_with_logits/Sub_1/y*
T0*
_output_shapes
: 

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
№
)softmax_cross_entropy_with_logits/Slice_1Slice)softmax_cross_entropy_with_logits/Shape_2/softmax_cross_entropy_with_logits/Slice_1/begin.softmax_cross_entropy_with_logits/Slice_1/size*
Index0*
T0*
_output_shapes
:

3softmax_cross_entropy_with_logits/concat_1/values_0Const*
dtype0*
_output_shapes
:*
valueB:
џџџџџџџџџ
q
/softmax_cross_entropy_with_logits/concat_1/axisConst*
value	B : *
dtype0*
_output_shapes
: 

*softmax_cross_entropy_with_logits/concat_1ConcatV23softmax_cross_entropy_with_logits/concat_1/values_0)softmax_cross_entropy_with_logits/Slice_1/softmax_cross_entropy_with_logits/concat_1/axis*
T0*
N*
_output_shapes
:*

Tidx0
К
+softmax_cross_entropy_with_logits/Reshape_1ReshapePlaceholder_1*softmax_cross_entropy_with_logits/concat_1*
T0*
Tshape0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
ф
!softmax_cross_entropy_with_logitsSoftmaxCrossEntropyWithLogits)softmax_cross_entropy_with_logits/Reshape+softmax_cross_entropy_with_logits/Reshape_1*
T0*?
_output_shapes-
+:џџџџџџџџџ:џџџџџџџџџџџџџџџџџџ
k
)softmax_cross_entropy_with_logits/Sub_2/yConst*
value	B :*
dtype0*
_output_shapes
: 
Ђ
'softmax_cross_entropy_with_logits/Sub_2Sub&softmax_cross_entropy_with_logits/Rank)softmax_cross_entropy_with_logits/Sub_2/y*
T0*
_output_shapes
: 
y
/softmax_cross_entropy_with_logits/Slice_2/beginConst*
valueB: *
dtype0*
_output_shapes
:

.softmax_cross_entropy_with_logits/Slice_2/sizePack'softmax_cross_entropy_with_logits/Sub_2*
T0*

axis *
N*
_output_shapes
:
ю
)softmax_cross_entropy_with_logits/Slice_2Slice'softmax_cross_entropy_with_logits/Shape/softmax_cross_entropy_with_logits/Slice_2/begin.softmax_cross_entropy_with_logits/Slice_2/size*
_output_shapes
:*
Index0*
T0
Р
+softmax_cross_entropy_with_logits/Reshape_2Reshape!softmax_cross_entropy_with_logits)softmax_cross_entropy_with_logits/Slice_2*
T0*
Tshape0*#
_output_shapes
:џџџџџџџџџ
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
: *
	keep_dims( *

Tidx0
R
gradients/ShapeConst*
valueB *
dtype0*
_output_shapes
: 
X
gradients/grad_ys_0Const*
valueB
 *  ?*
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

gradients/Mean_grad/ReshapeReshapegradients/Fill!gradients/Mean_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
:

gradients/Mean_grad/ShapeShape+softmax_cross_entropy_with_logits/Reshape_2*
_output_shapes
:*
T0*
out_type0

gradients/Mean_grad/TileTilegradients/Mean_grad/Reshapegradients/Mean_grad/Shape*

Tmultiples0*
T0*#
_output_shapes
:џџџџџџџџџ

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
gradients/Mean_grad/ConstConst*
dtype0*
_output_shapes
:*
valueB: 

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

gradients/Mean_grad/Prod_1Prodgradients/Mean_grad/Shape_2gradients/Mean_grad/Const_1*
T0*
_output_shapes
: *
	keep_dims( *

Tidx0
_
gradients/Mean_grad/Maximum/yConst*
value	B :*
dtype0*
_output_shapes
: 

gradients/Mean_grad/MaximumMaximumgradients/Mean_grad/Prod_1gradients/Mean_grad/Maximum/y*
T0*
_output_shapes
: 

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

gradients/Mean_grad/truedivRealDivgradients/Mean_grad/Tilegradients/Mean_grad/Cast*
T0*#
_output_shapes
:џџџџџџџџџ
Ё
@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ShapeShape!softmax_cross_entropy_with_logits*
T0*
out_type0*
_output_shapes
:
ш
Bgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeReshapegradients/Mean_grad/truediv@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Shape*
T0*
Tshape0*#
_output_shapes
:џџџџџџџџџ

gradients/zeros_like	ZerosLike#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ

?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dimConst*
dtype0*
_output_shapes
: *
valueB :
џџџџџџџџџ

;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Reshape?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dim*'
_output_shapes
:џџџџџџџџџ*

Tdim0*
T0
и
4gradients/softmax_cross_entropy_with_logits_grad/mulMul;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
Џ
;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax
LogSoftmax)softmax_cross_entropy_with_logits/Reshape*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ*
T0
Г
4gradients/softmax_cross_entropy_with_logits_grad/NegNeg;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ

Agradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dimConst*
dtype0*
_output_shapes
: *
valueB :
џџџџџџџџџ

=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeAgradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dim*'
_output_shapes
:џџџџџџџџџ*

Tdim0*
T0
э
6gradients/softmax_cross_entropy_with_logits_grad/mul_1Mul=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_14gradients/softmax_cross_entropy_with_logits_grad/Neg*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
Й
Agradients/softmax_cross_entropy_with_logits_grad/tuple/group_depsNoOp5^gradients/softmax_cross_entropy_with_logits_grad/mul7^gradients/softmax_cross_entropy_with_logits_grad/mul_1
г
Igradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependencyIdentity4gradients/softmax_cross_entropy_with_logits_grad/mulB^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ*
T0*G
_class=
;9loc:@gradients/softmax_cross_entropy_with_logits_grad/mul
й
Kgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency_1Identity6gradients/softmax_cross_entropy_with_logits_grad/mul_1B^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*I
_class?
=;loc:@gradients/softmax_cross_entropy_with_logits_grad/mul_1*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ

>gradients/softmax_cross_entropy_with_logits/Reshape_grad/ShapeShapeAdd_3*
T0*
out_type0*
_output_shapes
:

@gradients/softmax_cross_entropy_with_logits/Reshape_grad/ReshapeReshapeIgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency>gradients/softmax_cross_entropy_with_logits/Reshape_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ

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
К
*gradients/Add_3_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_3_grad/Shapegradients/Add_3_grad/Shape_1*
T0*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ
Э
gradients/Add_3_grad/SumSum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape*gradients/Add_3_grad/BroadcastGradientArgs*
	keep_dims( *

Tidx0*
T0*
_output_shapes
:

gradients/Add_3_grad/ReshapeReshapegradients/Add_3_grad/Sumgradients/Add_3_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ

б
gradients/Add_3_grad/Sum_1Sum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape,gradients/Add_3_grad/BroadcastGradientArgs:1*
_output_shapes
:*
	keep_dims( *

Tidx0*
T0

gradients/Add_3_grad/Reshape_1Reshapegradients/Add_3_grad/Sum_1gradients/Add_3_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:

m
%gradients/Add_3_grad/tuple/group_depsNoOp^gradients/Add_3_grad/Reshape^gradients/Add_3_grad/Reshape_1
т
-gradients/Add_3_grad/tuple/control_dependencyIdentitygradients/Add_3_grad/Reshape&^gradients/Add_3_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_3_grad/Reshape*'
_output_shapes
:џџџџџџџџџ

л
/gradients/Add_3_grad/tuple/control_dependency_1Identitygradients/Add_3_grad/Reshape_1&^gradients/Add_3_grad/tuple/group_deps*
_output_shapes
:
*
T0*1
_class'
%#loc:@gradients/Add_3_grad/Reshape_1
С
gradients/MatMul_3_grad/MatMulMatMul-gradients/Add_3_grad/tuple/control_dependencyout_weights/read*
T0*'
_output_shapes
:џџџџџџџџџ *
transpose_a( *
transpose_b(
Г
 gradients/MatMul_3_grad/MatMul_1MatMul	Sigmoid_2-gradients/Add_3_grad/tuple/control_dependency*
_output_shapes

: 
*
transpose_a(*
transpose_b( *
T0
t
(gradients/MatMul_3_grad/tuple/group_depsNoOp^gradients/MatMul_3_grad/MatMul!^gradients/MatMul_3_grad/MatMul_1
ь
0gradients/MatMul_3_grad/tuple/control_dependencyIdentitygradients/MatMul_3_grad/MatMul)^gradients/MatMul_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_3_grad/MatMul*'
_output_shapes
:џџџџџџџџџ 
щ
2gradients/MatMul_3_grad/tuple/control_dependency_1Identity gradients/MatMul_3_grad/MatMul_1)^gradients/MatMul_3_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_3_grad/MatMul_1*
_output_shapes

: 

Ђ
$gradients/Sigmoid_2_grad/SigmoidGradSigmoidGrad	Sigmoid_20gradients/MatMul_3_grad/tuple/control_dependency*'
_output_shapes
:џџџџџџџџџ *
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
К
*gradients/Add_2_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_2_grad/Shapegradients/Add_2_grad/Shape_1*
T0*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ
Б
gradients/Add_2_grad/SumSum$gradients/Sigmoid_2_grad/SigmoidGrad*gradients/Add_2_grad/BroadcastGradientArgs*
_output_shapes
:*
	keep_dims( *

Tidx0*
T0

gradients/Add_2_grad/ReshapeReshapegradients/Add_2_grad/Sumgradients/Add_2_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ 
Е
gradients/Add_2_grad/Sum_1Sum$gradients/Sigmoid_2_grad/SigmoidGrad,gradients/Add_2_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0

gradients/Add_2_grad/Reshape_1Reshapegradients/Add_2_grad/Sum_1gradients/Add_2_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
m
%gradients/Add_2_grad/tuple/group_depsNoOp^gradients/Add_2_grad/Reshape^gradients/Add_2_grad/Reshape_1
т
-gradients/Add_2_grad/tuple/control_dependencyIdentitygradients/Add_2_grad/Reshape&^gradients/Add_2_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_2_grad/Reshape*'
_output_shapes
:џџџџџџџџџ 
л
/gradients/Add_2_grad/tuple/control_dependency_1Identitygradients/Add_2_grad/Reshape_1&^gradients/Add_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_2_grad/Reshape_1*
_output_shapes
: 
Р
gradients/MatMul_2_grad/MatMulMatMul-gradients/Add_2_grad/tuple/control_dependencyl3_weights/read*
T0*'
_output_shapes
:џџџџџџџџџ@*
transpose_a( *
transpose_b(
Г
 gradients/MatMul_2_grad/MatMul_1MatMul	Sigmoid_1-gradients/Add_2_grad/tuple/control_dependency*
_output_shapes

:@ *
transpose_a(*
transpose_b( *
T0
t
(gradients/MatMul_2_grad/tuple/group_depsNoOp^gradients/MatMul_2_grad/MatMul!^gradients/MatMul_2_grad/MatMul_1
ь
0gradients/MatMul_2_grad/tuple/control_dependencyIdentitygradients/MatMul_2_grad/MatMul)^gradients/MatMul_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_2_grad/MatMul*'
_output_shapes
:џџџџџџџџџ@
щ
2gradients/MatMul_2_grad/tuple/control_dependency_1Identity gradients/MatMul_2_grad/MatMul_1)^gradients/MatMul_2_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_2_grad/MatMul_1*
_output_shapes

:@ 
Ђ
$gradients/Sigmoid_1_grad/SigmoidGradSigmoidGrad	Sigmoid_10gradients/MatMul_2_grad/tuple/control_dependency*
T0*'
_output_shapes
:џџџџџџџџџ@
b
gradients/Add_1_grad/ShapeShapeMatMul_1*
T0*
out_type0*
_output_shapes
:
f
gradients/Add_1_grad/Shape_1Const*
dtype0*
_output_shapes
:*
valueB:@
К
*gradients/Add_1_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_1_grad/Shapegradients/Add_1_grad/Shape_1*
T0*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ
Б
gradients/Add_1_grad/SumSum$gradients/Sigmoid_1_grad/SigmoidGrad*gradients/Add_1_grad/BroadcastGradientArgs*
	keep_dims( *

Tidx0*
T0*
_output_shapes
:

gradients/Add_1_grad/ReshapeReshapegradients/Add_1_grad/Sumgradients/Add_1_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ@
Е
gradients/Add_1_grad/Sum_1Sum$gradients/Sigmoid_1_grad/SigmoidGrad,gradients/Add_1_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0

gradients/Add_1_grad/Reshape_1Reshapegradients/Add_1_grad/Sum_1gradients/Add_1_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:@
m
%gradients/Add_1_grad/tuple/group_depsNoOp^gradients/Add_1_grad/Reshape^gradients/Add_1_grad/Reshape_1
т
-gradients/Add_1_grad/tuple/control_dependencyIdentitygradients/Add_1_grad/Reshape&^gradients/Add_1_grad/tuple/group_deps*'
_output_shapes
:џџџџџџџџџ@*
T0*/
_class%
#!loc:@gradients/Add_1_grad/Reshape
л
/gradients/Add_1_grad/tuple/control_dependency_1Identitygradients/Add_1_grad/Reshape_1&^gradients/Add_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_1_grad/Reshape_1*
_output_shapes
:@
С
gradients/MatMul_1_grad/MatMulMatMul-gradients/Add_1_grad/tuple/control_dependencyl2_weights/read*
T0*(
_output_shapes
:џџџџџџџџџ*
transpose_a( *
transpose_b(
В
 gradients/MatMul_1_grad/MatMul_1MatMulSigmoid-gradients/Add_1_grad/tuple/control_dependency*
T0*
_output_shapes
:	@*
transpose_a(*
transpose_b( 
t
(gradients/MatMul_1_grad/tuple/group_depsNoOp^gradients/MatMul_1_grad/MatMul!^gradients/MatMul_1_grad/MatMul_1
э
0gradients/MatMul_1_grad/tuple/control_dependencyIdentitygradients/MatMul_1_grad/MatMul)^gradients/MatMul_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_1_grad/MatMul*(
_output_shapes
:џџџџџџџџџ
ъ
2gradients/MatMul_1_grad/tuple/control_dependency_1Identity gradients/MatMul_1_grad/MatMul_1)^gradients/MatMul_1_grad/tuple/group_deps*
_output_shapes
:	@*
T0*3
_class)
'%loc:@gradients/MatMul_1_grad/MatMul_1

"gradients/Sigmoid_grad/SigmoidGradSigmoidGradSigmoid0gradients/MatMul_1_grad/tuple/control_dependency*
T0*(
_output_shapes
:џџџџџџџџџ
^
gradients/Add_grad/ShapeShapeMatMul*
_output_shapes
:*
T0*
out_type0
e
gradients/Add_grad/Shape_1Const*
dtype0*
_output_shapes
:*
valueB:
Д
(gradients/Add_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_grad/Shapegradients/Add_grad/Shape_1*
T0*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ
Ћ
gradients/Add_grad/SumSum"gradients/Sigmoid_grad/SigmoidGrad(gradients/Add_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0

gradients/Add_grad/ReshapeReshapegradients/Add_grad/Sumgradients/Add_grad/Shape*
T0*
Tshape0*(
_output_shapes
:џџџџџџџџџ
Џ
gradients/Add_grad/Sum_1Sum"gradients/Sigmoid_grad/SigmoidGrad*gradients/Add_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*
	keep_dims( *

Tidx0

gradients/Add_grad/Reshape_1Reshapegradients/Add_grad/Sum_1gradients/Add_grad/Shape_1*
T0*
Tshape0*
_output_shapes	
:
g
#gradients/Add_grad/tuple/group_depsNoOp^gradients/Add_grad/Reshape^gradients/Add_grad/Reshape_1
л
+gradients/Add_grad/tuple/control_dependencyIdentitygradients/Add_grad/Reshape$^gradients/Add_grad/tuple/group_deps*
T0*-
_class#
!loc:@gradients/Add_grad/Reshape*(
_output_shapes
:џџџџџџџџџ
д
-gradients/Add_grad/tuple/control_dependency_1Identitygradients/Add_grad/Reshape_1$^gradients/Add_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_grad/Reshape_1*
_output_shapes	
:
Н
gradients/MatMul_grad/MatMulMatMul+gradients/Add_grad/tuple/control_dependencyl1_weights/read*
transpose_b(*
T0*(
_output_shapes
:џџџџџџџџџ*
transpose_a( 
Г
gradients/MatMul_grad/MatMul_1MatMulPlaceholder+gradients/Add_grad/tuple/control_dependency*
T0* 
_output_shapes
:
*
transpose_a(*
transpose_b( 
n
&gradients/MatMul_grad/tuple/group_depsNoOp^gradients/MatMul_grad/MatMul^gradients/MatMul_grad/MatMul_1
х
.gradients/MatMul_grad/tuple/control_dependencyIdentitygradients/MatMul_grad/MatMul'^gradients/MatMul_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/MatMul_grad/MatMul*(
_output_shapes
:џџџџџџџџџ
у
0gradients/MatMul_grad/tuple/control_dependency_1Identitygradients/MatMul_grad/MatMul_1'^gradients/MatMul_grad/tuple/group_deps* 
_output_shapes
:
*
T0*1
_class'
%#loc:@gradients/MatMul_grad/MatMul_1
z
beta1_power/initial_valueConst*
valueB
 *fff?*
_class
loc:@l1_bias*
dtype0*
_output_shapes
: 

beta1_power
VariableV2*
shared_name *
_class
loc:@l1_bias*
	container *
shape: *
dtype0*
_output_shapes
: 
Њ
beta1_power/AssignAssignbeta1_powerbeta1_power/initial_value*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l1_bias
f
beta1_power/readIdentitybeta1_power*
_output_shapes
: *
T0*
_class
loc:@l1_bias
z
beta2_power/initial_valueConst*
valueB
 *wО?*
_class
loc:@l1_bias*
dtype0*
_output_shapes
: 

beta2_power
VariableV2*
shape: *
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l1_bias*
	container 
Њ
beta2_power/AssignAssignbeta2_powerbeta2_power/initial_value*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l1_bias
f
beta2_power/readIdentitybeta2_power*
T0*
_class
loc:@l1_bias*
_output_shapes
: 
Ё
1l1_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l1_weights*
valueB"     *
dtype0*
_output_shapes
:

'l1_weights/Adam/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
_class
loc:@l1_weights*
valueB
 *    
с
!l1_weights/Adam/Initializer/zerosFill1l1_weights/Adam/Initializer/zeros/shape_as_tensor'l1_weights/Adam/Initializer/zeros/Const*
T0*
_class
loc:@l1_weights*

index_type0* 
_output_shapes
:

І
l1_weights/Adam
VariableV2*
shared_name *
_class
loc:@l1_weights*
	container *
shape:
*
dtype0* 
_output_shapes
:

Ч
l1_weights/Adam/AssignAssignl1_weights/Adam!l1_weights/Adam/Initializer/zeros*
validate_shape(* 
_output_shapes
:
*
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

Ѓ
3l1_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
_class
loc:@l1_weights*
valueB"     

)l1_weights/Adam_1/Initializer/zeros/ConstConst*
_class
loc:@l1_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
ч
#l1_weights/Adam_1/Initializer/zerosFill3l1_weights/Adam_1/Initializer/zeros/shape_as_tensor)l1_weights/Adam_1/Initializer/zeros/Const*
T0*
_class
loc:@l1_weights*

index_type0* 
_output_shapes
:

Ј
l1_weights/Adam_1
VariableV2*
dtype0* 
_output_shapes
:
*
shared_name *
_class
loc:@l1_weights*
	container *
shape:

Э
l1_weights/Adam_1/AssignAssignl1_weights/Adam_1#l1_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:


l1_weights/Adam_1/readIdentityl1_weights/Adam_1*
T0*
_class
loc:@l1_weights* 
_output_shapes
:


l1_bias/Adam/Initializer/zerosConst*
_class
loc:@l1_bias*
valueB*    *
dtype0*
_output_shapes	
:

l1_bias/Adam
VariableV2*
	container *
shape:*
dtype0*
_output_shapes	
:*
shared_name *
_class
loc:@l1_bias
Ж
l1_bias/Adam/AssignAssignl1_bias/Adaml1_bias/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:
m
l1_bias/Adam/readIdentityl1_bias/Adam*
T0*
_class
loc:@l1_bias*
_output_shapes	
:

 l1_bias/Adam_1/Initializer/zerosConst*
_class
loc:@l1_bias*
valueB*    *
dtype0*
_output_shapes	
:

l1_bias/Adam_1
VariableV2*
dtype0*
_output_shapes	
:*
shared_name *
_class
loc:@l1_bias*
	container *
shape:
М
l1_bias/Adam_1/AssignAssignl1_bias/Adam_1 l1_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
q
l1_bias/Adam_1/readIdentityl1_bias/Adam_1*
T0*
_class
loc:@l1_bias*
_output_shapes	
:
Ё
1l2_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l2_weights*
valueB"   @   *
dtype0*
_output_shapes
:

'l2_weights/Adam/Initializer/zeros/ConstConst*
_class
loc:@l2_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
р
!l2_weights/Adam/Initializer/zerosFill1l2_weights/Adam/Initializer/zeros/shape_as_tensor'l2_weights/Adam/Initializer/zeros/Const*
_output_shapes
:	@*
T0*
_class
loc:@l2_weights*

index_type0
Є
l2_weights/Adam
VariableV2*
_class
loc:@l2_weights*
	container *
shape:	@*
dtype0*
_output_shapes
:	@*
shared_name 
Ц
l2_weights/Adam/AssignAssignl2_weights/Adam!l2_weights/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights
z
l2_weights/Adam/readIdentityl2_weights/Adam*
T0*
_class
loc:@l2_weights*
_output_shapes
:	@
Ѓ
3l2_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l2_weights*
valueB"   @   *
dtype0*
_output_shapes
:

)l2_weights/Adam_1/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
_class
loc:@l2_weights*
valueB
 *    
ц
#l2_weights/Adam_1/Initializer/zerosFill3l2_weights/Adam_1/Initializer/zeros/shape_as_tensor)l2_weights/Adam_1/Initializer/zeros/Const*
T0*
_class
loc:@l2_weights*

index_type0*
_output_shapes
:	@
І
l2_weights/Adam_1
VariableV2*
dtype0*
_output_shapes
:	@*
shared_name *
_class
loc:@l2_weights*
	container *
shape:	@
Ь
l2_weights/Adam_1/AssignAssignl2_weights/Adam_1#l2_weights/Adam_1/Initializer/zeros*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@*
use_locking(
~
l2_weights/Adam_1/readIdentityl2_weights/Adam_1*
T0*
_class
loc:@l2_weights*
_output_shapes
:	@

l2_bias/Adam/Initializer/zerosConst*
_class
loc:@l2_bias*
valueB@*    *
dtype0*
_output_shapes
:@

l2_bias/Adam
VariableV2*
dtype0*
_output_shapes
:@*
shared_name *
_class
loc:@l2_bias*
	container *
shape:@
Е
l2_bias/Adam/AssignAssignl2_bias/Adaml2_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
l
l2_bias/Adam/readIdentityl2_bias/Adam*
T0*
_class
loc:@l2_bias*
_output_shapes
:@

 l2_bias/Adam_1/Initializer/zerosConst*
_class
loc:@l2_bias*
valueB@*    *
dtype0*
_output_shapes
:@

l2_bias/Adam_1
VariableV2*
	container *
shape:@*
dtype0*
_output_shapes
:@*
shared_name *
_class
loc:@l2_bias
Л
l2_bias/Adam_1/AssignAssignl2_bias/Adam_1 l2_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
p
l2_bias/Adam_1/readIdentityl2_bias/Adam_1*
T0*
_class
loc:@l2_bias*
_output_shapes
:@
Ё
1l3_weights/Adam/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l3_weights*
valueB"@       *
dtype0*
_output_shapes
:

'l3_weights/Adam/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
_class
loc:@l3_weights*
valueB
 *    
п
!l3_weights/Adam/Initializer/zerosFill1l3_weights/Adam/Initializer/zeros/shape_as_tensor'l3_weights/Adam/Initializer/zeros/Const*
T0*
_class
loc:@l3_weights*

index_type0*
_output_shapes

:@ 
Ђ
l3_weights/Adam
VariableV2*
shared_name *
_class
loc:@l3_weights*
	container *
shape
:@ *
dtype0*
_output_shapes

:@ 
Х
l3_weights/Adam/AssignAssignl3_weights/Adam!l3_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
y
l3_weights/Adam/readIdentityl3_weights/Adam*
T0*
_class
loc:@l3_weights*
_output_shapes

:@ 
Ѓ
3l3_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
_class
loc:@l3_weights*
valueB"@       *
dtype0*
_output_shapes
:

)l3_weights/Adam_1/Initializer/zeros/ConstConst*
_class
loc:@l3_weights*
valueB
 *    *
dtype0*
_output_shapes
: 
х
#l3_weights/Adam_1/Initializer/zerosFill3l3_weights/Adam_1/Initializer/zeros/shape_as_tensor)l3_weights/Adam_1/Initializer/zeros/Const*
T0*
_class
loc:@l3_weights*

index_type0*
_output_shapes

:@ 
Є
l3_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@l3_weights*
	container *
shape
:@ *
dtype0*
_output_shapes

:@ 
Ы
l3_weights/Adam_1/AssignAssignl3_weights/Adam_1#l3_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
}
l3_weights/Adam_1/readIdentityl3_weights/Adam_1*
T0*
_class
loc:@l3_weights*
_output_shapes

:@ 

l3_bias/Adam/Initializer/zerosConst*
_class
loc:@l3_bias*
valueB *    *
dtype0*
_output_shapes
: 

l3_bias/Adam
VariableV2*
_class
loc:@l3_bias*
	container *
shape: *
dtype0*
_output_shapes
: *
shared_name 
Е
l3_bias/Adam/AssignAssignl3_bias/Adaml3_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
l
l3_bias/Adam/readIdentityl3_bias/Adam*
_output_shapes
: *
T0*
_class
loc:@l3_bias

 l3_bias/Adam_1/Initializer/zerosConst*
dtype0*
_output_shapes
: *
_class
loc:@l3_bias*
valueB *    

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
Л
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

"out_weights/Adam/Initializer/zerosConst*
dtype0*
_output_shapes

: 
*
_class
loc:@out_weights*
valueB 
*    
Є
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

Щ
out_weights/Adam/AssignAssignout_weights/Adam"out_weights/Adam/Initializer/zeros*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
|
out_weights/Adam/readIdentityout_weights/Adam*
T0*
_class
loc:@out_weights*
_output_shapes

: 


$out_weights/Adam_1/Initializer/zerosConst*
_class
loc:@out_weights*
valueB 
*    *
dtype0*
_output_shapes

: 

І
out_weights/Adam_1
VariableV2*
	container *
shape
: 
*
dtype0*
_output_shapes

: 
*
shared_name *
_class
loc:@out_weights
Я
out_weights/Adam_1/AssignAssignout_weights/Adam_1$out_weights/Adam_1/Initializer/zeros*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(

out_weights/Adam_1/readIdentityout_weights/Adam_1*
T0*
_class
loc:@out_weights*
_output_shapes

: 


out_bias/Adam/Initializer/zerosConst*
_class
loc:@out_bias*
valueB
*    *
dtype0*
_output_shapes
:


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
Й
out_bias/Adam/AssignAssignout_bias/Adamout_bias/Adam/Initializer/zeros*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:
*
use_locking(
o
out_bias/Adam/readIdentityout_bias/Adam*
_output_shapes
:
*
T0*
_class
loc:@out_bias

!out_bias/Adam_1/Initializer/zerosConst*
_class
loc:@out_bias*
valueB
*    *
dtype0*
_output_shapes
:


out_bias/Adam_1
VariableV2*
dtype0*
_output_shapes
:
*
shared_name *
_class
loc:@out_bias*
	container *
shape:

П
out_bias/Adam_1/AssignAssignout_bias/Adam_1!out_bias/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

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
 *o:
O

Adam/beta1Const*
valueB
 *fff?*
dtype0*
_output_shapes
: 
O

Adam/beta2Const*
valueB
 *wО?*
dtype0*
_output_shapes
: 
Q
Adam/epsilonConst*
dtype0*
_output_shapes
: *
valueB
 *wЬ+2
о
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
*
use_locking( 
Ч
Adam/update_l1_bias/ApplyAdam	ApplyAdaml1_biasl1_bias/Adaml1_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon-gradients/Add_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l1_bias*
use_nesterov( *
_output_shapes	
:
п
 Adam/update_l2_weights/ApplyAdam	ApplyAdam
l2_weightsl2_weights/Adaml2_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_1_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l2_weights*
use_nesterov( *
_output_shapes
:	@
Ш
Adam/update_l2_bias/ApplyAdam	ApplyAdaml2_biasl2_bias/Adaml2_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_1_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l2_bias*
use_nesterov( *
_output_shapes
:@
о
 Adam/update_l3_weights/ApplyAdam	ApplyAdam
l3_weightsl3_weights/Adaml3_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_2_grad/tuple/control_dependency_1*
T0*
_class
loc:@l3_weights*
use_nesterov( *
_output_shapes

:@ *
use_locking( 
Ш
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
у
!Adam/update_out_weights/ApplyAdam	ApplyAdamout_weightsout_weights/Adamout_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_3_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@out_weights*
use_nesterov( *
_output_shapes

: 

Э
Adam/update_out_bias/ApplyAdam	ApplyAdamout_biasout_bias/Adamout_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_3_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@out_bias*
use_nesterov( *
_output_shapes
:

ј
Adam/mulMulbeta1_power/read
Adam/beta1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 

Adam/AssignAssignbeta1_powerAdam/mul*
validate_shape(*
_output_shapes
: *
use_locking( *
T0*
_class
loc:@l1_bias
њ

Adam/mul_1Mulbeta2_power/read
Adam/beta2^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 

Adam/Assign_1Assignbeta2_power
Adam/mul_1*
validate_shape(*
_output_shapes
: *
use_locking( *
T0*
_class
loc:@l1_bias
И
AdamNoOp^Adam/Assign^Adam/Assign_1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam
и
initNoOp^beta1_power/Assign^beta2_power/Assign^l1_bias/Adam/Assign^l1_bias/Adam_1/Assign^l1_bias/Assign^l1_weights/Adam/Assign^l1_weights/Adam_1/Assign^l1_weights/Assign^l2_bias/Adam/Assign^l2_bias/Adam_1/Assign^l2_bias/Assign^l2_weights/Adam/Assign^l2_weights/Adam_1/Assign^l2_weights/Assign^l3_bias/Adam/Assign^l3_bias/Adam_1/Assign^l3_bias/Assign^l3_weights/Adam/Assign^l3_weights/Adam_1/Assign^l3_weights/Assign^out_bias/Adam/Assign^out_bias/Adam_1/Assign^out_bias/Assign^out_weights/Adam/Assign^out_weights/Adam_1/Assign^out_weights/Assign
R
ArgMax/dimensionConst*
value	B :*
dtype0*
_output_shapes
: 
v
ArgMaxArgMaxAdd_3ArgMax/dimension*
T0*
output_type0	*#
_output_shapes
:џџџџџџџџџ*

Tidx0
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
rangeRangerange/startRankrange/delta*#
_output_shapes
:џџџџџџџџџ*

Tidx0
Y
Mean_1MeanCastrange*
_output_shapes
: *
	keep_dims( *

Tidx0*
T0
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
dtype0*
_output_shapes
: *
shape: 
о
save/SaveV2/tensor_namesConst*
valueBBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:

save/SaveV2/shape_and_slicesConst*
dtype0*
_output_shapes
:*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B 
џ
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
№
save/RestoreV2/tensor_namesConst"/device:CPU:0*
valueBBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:
Љ
save/RestoreV2/shape_and_slicesConst"/device:CPU:0*
dtype0*
_output_shapes
:*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B 

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*|
_output_shapesj
h::::::::::::::::::::::::::*(
dtypes
2

save/AssignAssignbeta1_powersave/RestoreV2*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: *
use_locking(

save/Assign_1Assignbeta2_powersave/RestoreV2:1*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 

save/Assign_2Assignl1_biassave/RestoreV2:2*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
Ђ
save/Assign_3Assignl1_bias/Adamsave/RestoreV2:3*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:
Є
save/Assign_4Assignl1_bias/Adam_1save/RestoreV2:4*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:*
use_locking(
Ј
save/Assign_5Assign
l1_weightssave/RestoreV2:5*
validate_shape(* 
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@l1_weights
­
save/Assign_6Assignl1_weights/Adamsave/RestoreV2:6*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:

Џ
save/Assign_7Assignl1_weights/Adam_1save/RestoreV2:7*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
*
use_locking(

save/Assign_8Assignl2_biassave/RestoreV2:8*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes
:@*
use_locking(
Ё
save/Assign_9Assignl2_bias/Adamsave/RestoreV2:9*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes
:@
Ѕ
save/Assign_10Assignl2_bias/Adam_1save/RestoreV2:10*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
Љ
save/Assign_11Assign
l2_weightssave/RestoreV2:11*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@*
use_locking(
Ў
save/Assign_12Assignl2_weights/Adamsave/RestoreV2:12*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights
А
save/Assign_13Assignl2_weights/Adam_1save/RestoreV2:13*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights

save/Assign_14Assignl3_biassave/RestoreV2:14*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l3_bias
Ѓ
save/Assign_15Assignl3_bias/Adamsave/RestoreV2:15*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
Ѕ
save/Assign_16Assignl3_bias/Adam_1save/RestoreV2:16*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
Ј
save/Assign_17Assign
l3_weightssave/RestoreV2:17*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ *
use_locking(
­
save/Assign_18Assignl3_weights/Adamsave/RestoreV2:18*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
Џ
save/Assign_19Assignl3_weights/Adam_1save/RestoreV2:19*
validate_shape(*
_output_shapes

:@ *
use_locking(*
T0*
_class
loc:@l3_weights
 
save/Assign_20Assignout_biassave/RestoreV2:20*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

Ѕ
save/Assign_21Assignout_bias/Adamsave/RestoreV2:21*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

Ї
save/Assign_22Assignout_bias/Adam_1save/RestoreV2:22*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

Њ
save/Assign_23Assignout_weightssave/RestoreV2:23*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
Џ
save/Assign_24Assignout_weights/Adamsave/RestoreV2:24*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

Б
save/Assign_25Assignout_weights/Adam_1save/RestoreV2:25*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
Ц
save/restore_allNoOp^save/Assign^save/Assign_1^save/Assign_10^save/Assign_11^save/Assign_12^save/Assign_13^save/Assign_14^save/Assign_15^save/Assign_16^save/Assign_17^save/Assign_18^save/Assign_19^save/Assign_2^save/Assign_20^save/Assign_21^save/Assign_22^save/Assign_23^save/Assign_24^save/Assign_25^save/Assign_3^save/Assign_4^save/Assign_5^save/Assign_6^save/Assign_7^save/Assign_8^save/Assign_9"&iH(ў      =K`!	
"&зAJ§
п
:
Add
x"T
y"T
z"T"
Ttype:
2	
ю
	ApplyAdam
var"T	
m"T	
v"T
beta1_power"T
beta2_power"T
lr"T

beta1"T

beta2"T
epsilon"T	
grad"T
out"T" 
Ttype:
2	"
use_lockingbool( "
use_nesterovbool( 

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
ref"T

value"T

output_ref"T"	
Ttype"
validate_shapebool("
use_lockingbool(
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

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

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
2	
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

Prod

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( " 
Ttype:
2	"
Tidxtype0:
2	

RandomStandardNormal

shape"T
output"dtype"
seedint "
seed2int "
dtypetype:
2"
Ttype:
2	
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
list(type)(0
l
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
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

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
ref"dtype"
shapeshape"
dtypetype"
	containerstring "
shared_namestring 
&
	ZerosLike
x"T
y"T"	
Ttype*1.14.02v1.14.0-rc1-22-gaf24dc91b5Ш
p
PlaceholderPlaceholder*
dtype0*(
_output_shapes
:џџџџџџџџџ*
shape:џџџџџџџџџ
R
Placeholder_1Placeholder*
shape:*
dtype0*
_output_shapes
:
d
random_normal/shapeConst*
valueB"     *
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
 *  ?*
dtype0*
_output_shapes
: 
 
"random_normal/RandomStandardNormalRandomStandardNormalrandom_normal/shape*
T0*
dtype0*
seed2 * 
_output_shapes
:
*

seed 
}
random_normal/mulMul"random_normal/RandomStandardNormalrandom_normal/stddev*
T0* 
_output_shapes
:

f
random_normalAddrandom_normal/mulrandom_normal/mean*
T0* 
_output_shapes
:



l1_weights
VariableV2*
shared_name *
dtype0*
	container * 
_output_shapes
:
*
shape:

Љ
l1_weights/AssignAssign
l1_weightsrandom_normal*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
*
use_locking(
q
l1_weights/readIdentity
l1_weights* 
_output_shapes
:
*
T0*
_class
loc:@l1_weights
`
random_normal_1/shapeConst*
dtype0*
_output_shapes
:*
valueB:
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
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_1/RandomStandardNormalRandomStandardNormalrandom_normal_1/shape*
dtype0*
seed2 *
_output_shapes	
:*

seed *
T0
~
random_normal_1/mulMul$random_normal_1/RandomStandardNormalrandom_normal_1/stddev*
_output_shapes	
:*
T0
g
random_normal_1Addrandom_normal_1/mulrandom_normal_1/mean*
T0*
_output_shapes	
:
u
l1_bias
VariableV2*
shared_name *
dtype0*
	container *
_output_shapes	
:*
shape:

l1_bias/AssignAssignl1_biasrandom_normal_1*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
c
l1_bias/readIdentityl1_bias*
T0*
_class
loc:@l1_bias*
_output_shapes	
:
f
random_normal_2/shapeConst*
valueB"   @   *
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
random_normal_2/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  ?
Ѓ
$random_normal_2/RandomStandardNormalRandomStandardNormalrandom_normal_2/shape*
T0*
dtype0*
seed2 *
_output_shapes
:	@*

seed 

random_normal_2/mulMul$random_normal_2/RandomStandardNormalrandom_normal_2/stddev*
_output_shapes
:	@*
T0
k
random_normal_2Addrandom_normal_2/mulrandom_normal_2/mean*
T0*
_output_shapes
:	@


l2_weights
VariableV2*
dtype0*
	container *
_output_shapes
:	@*
shape:	@*
shared_name 
Њ
l2_weights/AssignAssign
l2_weightsrandom_normal_2*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@
p
l2_weights/readIdentity
l2_weights*
T0*
_class
loc:@l2_weights*
_output_shapes
:	@
_
random_normal_3/shapeConst*
dtype0*
_output_shapes
:*
valueB:@
Y
random_normal_3/meanConst*
valueB
 *    *
dtype0*
_output_shapes
: 
[
random_normal_3/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  ?

$random_normal_3/RandomStandardNormalRandomStandardNormalrandom_normal_3/shape*
T0*
dtype0*
seed2 *
_output_shapes
:@*

seed 
}
random_normal_3/mulMul$random_normal_3/RandomStandardNormalrandom_normal_3/stddev*
_output_shapes
:@*
T0
f
random_normal_3Addrandom_normal_3/mulrandom_normal_3/mean*
_output_shapes
:@*
T0
s
l2_bias
VariableV2*
dtype0*
	container *
_output_shapes
:@*
shape:@*
shared_name 

l2_bias/AssignAssignl2_biasrandom_normal_3*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes
:@
b
l2_bias/readIdentityl2_bias*
T0*
_class
loc:@l2_bias*
_output_shapes
:@
f
random_normal_4/shapeConst*
valueB"@       *
dtype0*
_output_shapes
:
Y
random_normal_4/meanConst*
dtype0*
_output_shapes
: *
valueB
 *    
[
random_normal_4/stddevConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 
Ђ
$random_normal_4/RandomStandardNormalRandomStandardNormalrandom_normal_4/shape*
dtype0*
seed2 *
_output_shapes

:@ *

seed *
T0

random_normal_4/mulMul$random_normal_4/RandomStandardNormalrandom_normal_4/stddev*
T0*
_output_shapes

:@ 
j
random_normal_4Addrandom_normal_4/mulrandom_normal_4/mean*
T0*
_output_shapes

:@ 
~

l3_weights
VariableV2*
shape
:@ *
shared_name *
dtype0*
	container *
_output_shapes

:@ 
Љ
l3_weights/AssignAssign
l3_weightsrandom_normal_4*
validate_shape(*
_output_shapes

:@ *
use_locking(*
T0*
_class
loc:@l3_weights
o
l3_weights/readIdentity
l3_weights*
T0*
_class
loc:@l3_weights*
_output_shapes

:@ 
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
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_5/RandomStandardNormalRandomStandardNormalrandom_normal_5/shape*

seed *
T0*
dtype0*
seed2 *
_output_shapes
: 
}
random_normal_5/mulMul$random_normal_5/RandomStandardNormalrandom_normal_5/stddev*
_output_shapes
: *
T0
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

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
random_normal_6/stddevConst*
dtype0*
_output_shapes
: *
valueB
 *  ?
Ђ
$random_normal_6/RandomStandardNormalRandomStandardNormalrandom_normal_6/shape*
dtype0*
seed2 *
_output_shapes

: 
*

seed *
T0

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
VariableV2*
dtype0*
	container *
_output_shapes

: 
*
shape
: 
*
shared_name 
Ќ
out_weights/AssignAssignout_weightsrandom_normal_6*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
r
out_weights/readIdentityout_weights*
T0*
_class
loc:@out_weights*
_output_shapes

: 

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
random_normal_7/stddevConst*
valueB
 *  ?*
dtype0*
_output_shapes
: 

$random_normal_7/RandomStandardNormalRandomStandardNormalrandom_normal_7/shape*
T0*
dtype0*
seed2 *
_output_shapes
:
*

seed 
}
random_normal_7/mulMul$random_normal_7/RandomStandardNormalrandom_normal_7/stddev*
_output_shapes
:
*
T0
f
random_normal_7Addrandom_normal_7/mulrandom_normal_7/mean*
T0*
_output_shapes
:

t
out_bias
VariableV2*
dtype0*
	container *
_output_shapes
:
*
shape:
*
shared_name 

out_bias/AssignAssignout_biasrandom_normal_7*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
e
out_bias/readIdentityout_bias*
T0*
_class
loc:@out_bias*
_output_shapes
:


MatMulMatMulPlaceholderl1_weights/read*
transpose_a( *(
_output_shapes
:џџџџџџџџџ*
transpose_b( *
T0
S
AddAddMatMull1_bias/read*
T0*(
_output_shapes
:џџџџџџџџџ
J
SigmoidSigmoidAdd*(
_output_shapes
:џџџџџџџџџ*
T0

MatMul_1MatMulSigmoidl2_weights/read*
transpose_a( *'
_output_shapes
:џџџџџџџџџ@*
transpose_b( *
T0
V
Add_1AddMatMul_1l2_bias/read*
T0*'
_output_shapes
:џџџџџџџџџ@
M
	Sigmoid_1SigmoidAdd_1*
T0*'
_output_shapes
:џџџџџџџџџ@

MatMul_2MatMul	Sigmoid_1l3_weights/read*
transpose_a( *'
_output_shapes
:џџџџџџџџџ *
transpose_b( *
T0
V
Add_2AddMatMul_2l3_bias/read*
T0*'
_output_shapes
:џџџџџџџџџ 
M
	Sigmoid_2SigmoidAdd_2*
T0*'
_output_shapes
:џџџџџџџџџ 

MatMul_3MatMul	Sigmoid_2out_weights/read*
T0*
transpose_a( *'
_output_shapes
:џџџџџџџџџ
*
transpose_b( 
W
Add_3AddMatMul_3out_bias/read*'
_output_shapes
:џџџџџџџџџ
*
T0
h
&softmax_cross_entropy_with_logits/RankConst*
value	B :*
dtype0*
_output_shapes
: 
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
'softmax_cross_entropy_with_logits/Sub/yConst*
value	B :*
dtype0*
_output_shapes
: 
 
%softmax_cross_entropy_with_logits/SubSub(softmax_cross_entropy_with_logits/Rank_1'softmax_cross_entropy_with_logits/Sub/y*
_output_shapes
: *
T0

-softmax_cross_entropy_with_logits/Slice/beginPack%softmax_cross_entropy_with_logits/Sub*
T0*

axis *
N*
_output_shapes
:
v
,softmax_cross_entropy_with_logits/Slice/sizeConst*
valueB:*
dtype0*
_output_shapes
:
ъ
'softmax_cross_entropy_with_logits/SliceSlice)softmax_cross_entropy_with_logits/Shape_1-softmax_cross_entropy_with_logits/Slice/begin,softmax_cross_entropy_with_logits/Slice/size*
T0*
Index0*
_output_shapes
:

1softmax_cross_entropy_with_logits/concat/values_0Const*
valueB:
џџџџџџџџџ*
dtype0*
_output_shapes
:
o
-softmax_cross_entropy_with_logits/concat/axisConst*
value	B : *
dtype0*
_output_shapes
: 
љ
(softmax_cross_entropy_with_logits/concatConcatV21softmax_cross_entropy_with_logits/concat/values_0'softmax_cross_entropy_with_logits/Slice-softmax_cross_entropy_with_logits/concat/axis*
T0*
N*
_output_shapes
:*

Tidx0
Ў
)softmax_cross_entropy_with_logits/ReshapeReshapeAdd_3(softmax_cross_entropy_with_logits/concat*
T0*
Tshape0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
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
:џџџџџџџџџ
k
)softmax_cross_entropy_with_logits/Sub_1/yConst*
value	B :*
dtype0*
_output_shapes
: 
Є
'softmax_cross_entropy_with_logits/Sub_1Sub(softmax_cross_entropy_with_logits/Rank_2)softmax_cross_entropy_with_logits/Sub_1/y*
T0*
_output_shapes
: 

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
№
)softmax_cross_entropy_with_logits/Slice_1Slice)softmax_cross_entropy_with_logits/Shape_2/softmax_cross_entropy_with_logits/Slice_1/begin.softmax_cross_entropy_with_logits/Slice_1/size*
T0*
Index0*
_output_shapes
:

3softmax_cross_entropy_with_logits/concat_1/values_0Const*
valueB:
џџџџџџџџџ*
dtype0*
_output_shapes
:
q
/softmax_cross_entropy_with_logits/concat_1/axisConst*
value	B : *
dtype0*
_output_shapes
: 

*softmax_cross_entropy_with_logits/concat_1ConcatV23softmax_cross_entropy_with_logits/concat_1/values_0)softmax_cross_entropy_with_logits/Slice_1/softmax_cross_entropy_with_logits/concat_1/axis*
N*
_output_shapes
:*

Tidx0*
T0
К
+softmax_cross_entropy_with_logits/Reshape_1ReshapePlaceholder_1*softmax_cross_entropy_with_logits/concat_1*
T0*
Tshape0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
ф
!softmax_cross_entropy_with_logitsSoftmaxCrossEntropyWithLogits)softmax_cross_entropy_with_logits/Reshape+softmax_cross_entropy_with_logits/Reshape_1*?
_output_shapes-
+:џџџџџџџџџ:џџџџџџџџџџџџџџџџџџ*
T0
k
)softmax_cross_entropy_with_logits/Sub_2/yConst*
value	B :*
dtype0*
_output_shapes
: 
Ђ
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

.softmax_cross_entropy_with_logits/Slice_2/sizePack'softmax_cross_entropy_with_logits/Sub_2*
T0*

axis *
N*
_output_shapes
:
ю
)softmax_cross_entropy_with_logits/Slice_2Slice'softmax_cross_entropy_with_logits/Shape/softmax_cross_entropy_with_logits/Slice_2/begin.softmax_cross_entropy_with_logits/Slice_2/size*
T0*
Index0*
_output_shapes
:
Р
+softmax_cross_entropy_with_logits/Reshape_2Reshape!softmax_cross_entropy_with_logits)softmax_cross_entropy_with_logits/Slice_2*#
_output_shapes
:џџџџџџџџџ*
T0*
Tshape0
O
ConstConst*
valueB: *
dtype0*
_output_shapes
:
~
MeanMean+softmax_cross_entropy_with_logits/Reshape_2Const*
_output_shapes
: *

Tidx0*
	keep_dims( *
T0
R
gradients/ShapeConst*
valueB *
dtype0*
_output_shapes
: 
X
gradients/grad_ys_0Const*
valueB
 *  ?*
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

gradients/Mean_grad/ReshapeReshapegradients/Fill!gradients/Mean_grad/Reshape/shape*
T0*
Tshape0*
_output_shapes
:

gradients/Mean_grad/ShapeShape+softmax_cross_entropy_with_logits/Reshape_2*
T0*
out_type0*
_output_shapes
:

gradients/Mean_grad/TileTilegradients/Mean_grad/Reshapegradients/Mean_grad/Shape*

Tmultiples0*
T0*#
_output_shapes
:џџџџџџџџџ

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

gradients/Mean_grad/ProdProdgradients/Mean_grad/Shape_1gradients/Mean_grad/Const*
T0*
_output_shapes
: *

Tidx0*
	keep_dims( 
e
gradients/Mean_grad/Const_1Const*
dtype0*
_output_shapes
:*
valueB: 

gradients/Mean_grad/Prod_1Prodgradients/Mean_grad/Shape_2gradients/Mean_grad/Const_1*

Tidx0*
	keep_dims( *
T0*
_output_shapes
: 
_
gradients/Mean_grad/Maximum/yConst*
value	B :*
dtype0*
_output_shapes
: 

gradients/Mean_grad/MaximumMaximumgradients/Mean_grad/Prod_1gradients/Mean_grad/Maximum/y*
_output_shapes
: *
T0

gradients/Mean_grad/floordivFloorDivgradients/Mean_grad/Prodgradients/Mean_grad/Maximum*
T0*
_output_shapes
: 
~
gradients/Mean_grad/CastCastgradients/Mean_grad/floordiv*

SrcT0*
Truncate( *

DstT0*
_output_shapes
: 

gradients/Mean_grad/truedivRealDivgradients/Mean_grad/Tilegradients/Mean_grad/Cast*
T0*#
_output_shapes
:џџџџџџџџџ
Ё
@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ShapeShape!softmax_cross_entropy_with_logits*
T0*
out_type0*
_output_shapes
:
ш
Bgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeReshapegradients/Mean_grad/truediv@gradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Shape*
T0*
Tshape0*#
_output_shapes
:џџџџџџџџџ

gradients/zeros_like	ZerosLike#softmax_cross_entropy_with_logits:1*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ*
T0

?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dimConst*
valueB :
џџџџџџџџџ*
dtype0*
_output_shapes
: 

;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/Reshape?gradients/softmax_cross_entropy_with_logits_grad/ExpandDims/dim*
T0*'
_output_shapes
:џџџџџџџџџ*

Tdim0
и
4gradients/softmax_cross_entropy_with_logits_grad/mulMul;gradients/softmax_cross_entropy_with_logits_grad/ExpandDims#softmax_cross_entropy_with_logits:1*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
Џ
;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax
LogSoftmax)softmax_cross_entropy_with_logits/Reshape*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
Г
4gradients/softmax_cross_entropy_with_logits_grad/NegNeg;gradients/softmax_cross_entropy_with_logits_grad/LogSoftmax*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ

Agradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dimConst*
valueB :
џџџџџџџџџ*
dtype0*
_output_shapes
: 

=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1
ExpandDimsBgradients/softmax_cross_entropy_with_logits/Reshape_2_grad/ReshapeAgradients/softmax_cross_entropy_with_logits_grad/ExpandDims_1/dim*
T0*'
_output_shapes
:џџџџџџџџџ*

Tdim0
э
6gradients/softmax_cross_entropy_with_logits_grad/mul_1Mul=gradients/softmax_cross_entropy_with_logits_grad/ExpandDims_14gradients/softmax_cross_entropy_with_logits_grad/Neg*
T0*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
Й
Agradients/softmax_cross_entropy_with_logits_grad/tuple/group_depsNoOp5^gradients/softmax_cross_entropy_with_logits_grad/mul7^gradients/softmax_cross_entropy_with_logits_grad/mul_1
г
Igradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependencyIdentity4gradients/softmax_cross_entropy_with_logits_grad/mulB^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*G
_class=
;9loc:@gradients/softmax_cross_entropy_with_logits_grad/mul*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ
й
Kgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency_1Identity6gradients/softmax_cross_entropy_with_logits_grad/mul_1B^gradients/softmax_cross_entropy_with_logits_grad/tuple/group_deps*
T0*I
_class?
=;loc:@gradients/softmax_cross_entropy_with_logits_grad/mul_1*0
_output_shapes
:џџџџџџџџџџџџџџџџџџ

>gradients/softmax_cross_entropy_with_logits/Reshape_grad/ShapeShapeAdd_3*
T0*
out_type0*
_output_shapes
:

@gradients/softmax_cross_entropy_with_logits/Reshape_grad/ReshapeReshapeIgradients/softmax_cross_entropy_with_logits_grad/tuple/control_dependency>gradients/softmax_cross_entropy_with_logits/Reshape_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ

b
gradients/Add_3_grad/ShapeShapeMatMul_3*
_output_shapes
:*
T0*
out_type0
f
gradients/Add_3_grad/Shape_1Const*
valueB:
*
dtype0*
_output_shapes
:
К
*gradients/Add_3_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_3_grad/Shapegradients/Add_3_grad/Shape_1*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ*
T0
Э
gradients/Add_3_grad/SumSum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape*gradients/Add_3_grad/BroadcastGradientArgs*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0

gradients/Add_3_grad/ReshapeReshapegradients/Add_3_grad/Sumgradients/Add_3_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ

б
gradients/Add_3_grad/Sum_1Sum@gradients/softmax_cross_entropy_with_logits/Reshape_grad/Reshape,gradients/Add_3_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/Add_3_grad/Reshape_1Reshapegradients/Add_3_grad/Sum_1gradients/Add_3_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:

m
%gradients/Add_3_grad/tuple/group_depsNoOp^gradients/Add_3_grad/Reshape^gradients/Add_3_grad/Reshape_1
т
-gradients/Add_3_grad/tuple/control_dependencyIdentitygradients/Add_3_grad/Reshape&^gradients/Add_3_grad/tuple/group_deps*'
_output_shapes
:џџџџџџџџџ
*
T0*/
_class%
#!loc:@gradients/Add_3_grad/Reshape
л
/gradients/Add_3_grad/tuple/control_dependency_1Identitygradients/Add_3_grad/Reshape_1&^gradients/Add_3_grad/tuple/group_deps*
_output_shapes
:
*
T0*1
_class'
%#loc:@gradients/Add_3_grad/Reshape_1
С
gradients/MatMul_3_grad/MatMulMatMul-gradients/Add_3_grad/tuple/control_dependencyout_weights/read*
transpose_a( *'
_output_shapes
:џџџџџџџџџ *
transpose_b(*
T0
Г
 gradients/MatMul_3_grad/MatMul_1MatMul	Sigmoid_2-gradients/Add_3_grad/tuple/control_dependency*
transpose_a(*
_output_shapes

: 
*
transpose_b( *
T0
t
(gradients/MatMul_3_grad/tuple/group_depsNoOp^gradients/MatMul_3_grad/MatMul!^gradients/MatMul_3_grad/MatMul_1
ь
0gradients/MatMul_3_grad/tuple/control_dependencyIdentitygradients/MatMul_3_grad/MatMul)^gradients/MatMul_3_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_3_grad/MatMul*'
_output_shapes
:џџџџџџџџџ 
щ
2gradients/MatMul_3_grad/tuple/control_dependency_1Identity gradients/MatMul_3_grad/MatMul_1)^gradients/MatMul_3_grad/tuple/group_deps*
_output_shapes

: 
*
T0*3
_class)
'%loc:@gradients/MatMul_3_grad/MatMul_1
Ђ
$gradients/Sigmoid_2_grad/SigmoidGradSigmoidGrad	Sigmoid_20gradients/MatMul_3_grad/tuple/control_dependency*
T0*'
_output_shapes
:џџџџџџџџџ 
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
К
*gradients/Add_2_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_2_grad/Shapegradients/Add_2_grad/Shape_1*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ*
T0
Б
gradients/Add_2_grad/SumSum$gradients/Sigmoid_2_grad/SigmoidGrad*gradients/Add_2_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/Add_2_grad/ReshapeReshapegradients/Add_2_grad/Sumgradients/Add_2_grad/Shape*
T0*
Tshape0*'
_output_shapes
:џџџџџџџџџ 
Е
gradients/Add_2_grad/Sum_1Sum$gradients/Sigmoid_2_grad/SigmoidGrad,gradients/Add_2_grad/BroadcastGradientArgs:1*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0

gradients/Add_2_grad/Reshape_1Reshapegradients/Add_2_grad/Sum_1gradients/Add_2_grad/Shape_1*
T0*
Tshape0*
_output_shapes
: 
m
%gradients/Add_2_grad/tuple/group_depsNoOp^gradients/Add_2_grad/Reshape^gradients/Add_2_grad/Reshape_1
т
-gradients/Add_2_grad/tuple/control_dependencyIdentitygradients/Add_2_grad/Reshape&^gradients/Add_2_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_2_grad/Reshape*'
_output_shapes
:џџџџџџџџџ 
л
/gradients/Add_2_grad/tuple/control_dependency_1Identitygradients/Add_2_grad/Reshape_1&^gradients/Add_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_2_grad/Reshape_1*
_output_shapes
: 
Р
gradients/MatMul_2_grad/MatMulMatMul-gradients/Add_2_grad/tuple/control_dependencyl3_weights/read*
transpose_b(*
T0*
transpose_a( *'
_output_shapes
:џџџџџџџџџ@
Г
 gradients/MatMul_2_grad/MatMul_1MatMul	Sigmoid_1-gradients/Add_2_grad/tuple/control_dependency*
T0*
transpose_a(*
_output_shapes

:@ *
transpose_b( 
t
(gradients/MatMul_2_grad/tuple/group_depsNoOp^gradients/MatMul_2_grad/MatMul!^gradients/MatMul_2_grad/MatMul_1
ь
0gradients/MatMul_2_grad/tuple/control_dependencyIdentitygradients/MatMul_2_grad/MatMul)^gradients/MatMul_2_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_2_grad/MatMul*'
_output_shapes
:џџџџџџџџџ@
щ
2gradients/MatMul_2_grad/tuple/control_dependency_1Identity gradients/MatMul_2_grad/MatMul_1)^gradients/MatMul_2_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_2_grad/MatMul_1*
_output_shapes

:@ 
Ђ
$gradients/Sigmoid_1_grad/SigmoidGradSigmoidGrad	Sigmoid_10gradients/MatMul_2_grad/tuple/control_dependency*
T0*'
_output_shapes
:џџџџџџџџџ@
b
gradients/Add_1_grad/ShapeShapeMatMul_1*
_output_shapes
:*
T0*
out_type0
f
gradients/Add_1_grad/Shape_1Const*
valueB:@*
dtype0*
_output_shapes
:
К
*gradients/Add_1_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_1_grad/Shapegradients/Add_1_grad/Shape_1*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ*
T0
Б
gradients/Add_1_grad/SumSum$gradients/Sigmoid_1_grad/SigmoidGrad*gradients/Add_1_grad/BroadcastGradientArgs*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/Add_1_grad/ReshapeReshapegradients/Add_1_grad/Sumgradients/Add_1_grad/Shape*'
_output_shapes
:џџџџџџџџџ@*
T0*
Tshape0
Е
gradients/Add_1_grad/Sum_1Sum$gradients/Sigmoid_1_grad/SigmoidGrad,gradients/Add_1_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/Add_1_grad/Reshape_1Reshapegradients/Add_1_grad/Sum_1gradients/Add_1_grad/Shape_1*
T0*
Tshape0*
_output_shapes
:@
m
%gradients/Add_1_grad/tuple/group_depsNoOp^gradients/Add_1_grad/Reshape^gradients/Add_1_grad/Reshape_1
т
-gradients/Add_1_grad/tuple/control_dependencyIdentitygradients/Add_1_grad/Reshape&^gradients/Add_1_grad/tuple/group_deps*
T0*/
_class%
#!loc:@gradients/Add_1_grad/Reshape*'
_output_shapes
:џџџџџџџџџ@
л
/gradients/Add_1_grad/tuple/control_dependency_1Identitygradients/Add_1_grad/Reshape_1&^gradients/Add_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/Add_1_grad/Reshape_1*
_output_shapes
:@
С
gradients/MatMul_1_grad/MatMulMatMul-gradients/Add_1_grad/tuple/control_dependencyl2_weights/read*
transpose_a( *(
_output_shapes
:џџџџџџџџџ*
transpose_b(*
T0
В
 gradients/MatMul_1_grad/MatMul_1MatMulSigmoid-gradients/Add_1_grad/tuple/control_dependency*
transpose_b( *
T0*
transpose_a(*
_output_shapes
:	@
t
(gradients/MatMul_1_grad/tuple/group_depsNoOp^gradients/MatMul_1_grad/MatMul!^gradients/MatMul_1_grad/MatMul_1
э
0gradients/MatMul_1_grad/tuple/control_dependencyIdentitygradients/MatMul_1_grad/MatMul)^gradients/MatMul_1_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_1_grad/MatMul*(
_output_shapes
:џџџџџџџџџ
ъ
2gradients/MatMul_1_grad/tuple/control_dependency_1Identity gradients/MatMul_1_grad/MatMul_1)^gradients/MatMul_1_grad/tuple/group_deps*
T0*3
_class)
'%loc:@gradients/MatMul_1_grad/MatMul_1*
_output_shapes
:	@

"gradients/Sigmoid_grad/SigmoidGradSigmoidGradSigmoid0gradients/MatMul_1_grad/tuple/control_dependency*
T0*(
_output_shapes
:џџџџџџџџџ
^
gradients/Add_grad/ShapeShapeMatMul*
T0*
out_type0*
_output_shapes
:
e
gradients/Add_grad/Shape_1Const*
dtype0*
_output_shapes
:*
valueB:
Д
(gradients/Add_grad/BroadcastGradientArgsBroadcastGradientArgsgradients/Add_grad/Shapegradients/Add_grad/Shape_1*2
_output_shapes 
:џџџџџџџџџ:џџџџџџџџџ*
T0
Ћ
gradients/Add_grad/SumSum"gradients/Sigmoid_grad/SigmoidGrad(gradients/Add_grad/BroadcastGradientArgs*
_output_shapes
:*

Tidx0*
	keep_dims( *
T0

gradients/Add_grad/ReshapeReshapegradients/Add_grad/Sumgradients/Add_grad/Shape*
T0*
Tshape0*(
_output_shapes
:џџџџџџџџџ
Џ
gradients/Add_grad/Sum_1Sum"gradients/Sigmoid_grad/SigmoidGrad*gradients/Add_grad/BroadcastGradientArgs:1*
T0*
_output_shapes
:*

Tidx0*
	keep_dims( 

gradients/Add_grad/Reshape_1Reshapegradients/Add_grad/Sum_1gradients/Add_grad/Shape_1*
_output_shapes	
:*
T0*
Tshape0
g
#gradients/Add_grad/tuple/group_depsNoOp^gradients/Add_grad/Reshape^gradients/Add_grad/Reshape_1
л
+gradients/Add_grad/tuple/control_dependencyIdentitygradients/Add_grad/Reshape$^gradients/Add_grad/tuple/group_deps*
T0*-
_class#
!loc:@gradients/Add_grad/Reshape*(
_output_shapes
:џџџџџџџџџ
д
-gradients/Add_grad/tuple/control_dependency_1Identitygradients/Add_grad/Reshape_1$^gradients/Add_grad/tuple/group_deps*
_output_shapes	
:*
T0*/
_class%
#!loc:@gradients/Add_grad/Reshape_1
Н
gradients/MatMul_grad/MatMulMatMul+gradients/Add_grad/tuple/control_dependencyl1_weights/read*
T0*
transpose_a( *(
_output_shapes
:џџџџџџџџџ*
transpose_b(
Г
gradients/MatMul_grad/MatMul_1MatMulPlaceholder+gradients/Add_grad/tuple/control_dependency*
transpose_a(* 
_output_shapes
:
*
transpose_b( *
T0
n
&gradients/MatMul_grad/tuple/group_depsNoOp^gradients/MatMul_grad/MatMul^gradients/MatMul_grad/MatMul_1
х
.gradients/MatMul_grad/tuple/control_dependencyIdentitygradients/MatMul_grad/MatMul'^gradients/MatMul_grad/tuple/group_deps*(
_output_shapes
:џџџџџџџџџ*
T0*/
_class%
#!loc:@gradients/MatMul_grad/MatMul
у
0gradients/MatMul_grad/tuple/control_dependency_1Identitygradients/MatMul_grad/MatMul_1'^gradients/MatMul_grad/tuple/group_deps*
T0*1
_class'
%#loc:@gradients/MatMul_grad/MatMul_1* 
_output_shapes
:

z
beta1_power/initial_valueConst*
_class
loc:@l1_bias*
valueB
 *fff?*
dtype0*
_output_shapes
: 

beta1_power
VariableV2*
shape: *
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l1_bias*
	container 
Њ
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
: *
_class
loc:@l1_bias*
valueB
 *wО?

beta2_power
VariableV2*
shape: *
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l1_bias*
	container 
Њ
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
Ё
1l1_weights/Adam/Initializer/zeros/shape_as_tensorConst*
valueB"     *
_class
loc:@l1_weights*
dtype0*
_output_shapes
:

'l1_weights/Adam/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l1_weights*
dtype0*
_output_shapes
: 
с
!l1_weights/Adam/Initializer/zerosFill1l1_weights/Adam/Initializer/zeros/shape_as_tensor'l1_weights/Adam/Initializer/zeros/Const* 
_output_shapes
:
*
T0*

index_type0*
_class
loc:@l1_weights
І
l1_weights/Adam
VariableV2*
shape:
*
dtype0* 
_output_shapes
:
*
shared_name *
_class
loc:@l1_weights*
	container 
Ч
l1_weights/Adam/AssignAssignl1_weights/Adam!l1_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:

{
l1_weights/Adam/readIdentityl1_weights/Adam*
T0*
_class
loc:@l1_weights* 
_output_shapes
:

Ѓ
3l1_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
valueB"     *
_class
loc:@l1_weights*
dtype0*
_output_shapes
:

)l1_weights/Adam_1/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
valueB
 *    *
_class
loc:@l1_weights
ч
#l1_weights/Adam_1/Initializer/zerosFill3l1_weights/Adam_1/Initializer/zeros/shape_as_tensor)l1_weights/Adam_1/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l1_weights* 
_output_shapes
:

Ј
l1_weights/Adam_1
VariableV2*
dtype0* 
_output_shapes
:
*
shared_name *
_class
loc:@l1_weights*
	container *
shape:

Э
l1_weights/Adam_1/AssignAssignl1_weights/Adam_1#l1_weights/Adam_1/Initializer/zeros*
validate_shape(* 
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@l1_weights

l1_weights/Adam_1/readIdentityl1_weights/Adam_1*
T0*
_class
loc:@l1_weights* 
_output_shapes
:


l1_bias/Adam/Initializer/zerosConst*
valueB*    *
_class
loc:@l1_bias*
dtype0*
_output_shapes	
:

l1_bias/Adam
VariableV2*
dtype0*
_output_shapes	
:*
shared_name *
_class
loc:@l1_bias*
	container *
shape:
Ж
l1_bias/Adam/AssignAssignl1_bias/Adaml1_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
m
l1_bias/Adam/readIdentityl1_bias/Adam*
T0*
_class
loc:@l1_bias*
_output_shapes	
:

 l1_bias/Adam_1/Initializer/zerosConst*
valueB*    *
_class
loc:@l1_bias*
dtype0*
_output_shapes	
:

l1_bias/Adam_1
VariableV2*
_class
loc:@l1_bias*
	container *
shape:*
dtype0*
_output_shapes	
:*
shared_name 
М
l1_bias/Adam_1/AssignAssignl1_bias/Adam_1 l1_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
q
l1_bias/Adam_1/readIdentityl1_bias/Adam_1*
T0*
_class
loc:@l1_bias*
_output_shapes	
:
Ё
1l2_weights/Adam/Initializer/zeros/shape_as_tensorConst*
valueB"   @   *
_class
loc:@l2_weights*
dtype0*
_output_shapes
:

'l2_weights/Adam/Initializer/zeros/ConstConst*
dtype0*
_output_shapes
: *
valueB
 *    *
_class
loc:@l2_weights
р
!l2_weights/Adam/Initializer/zerosFill1l2_weights/Adam/Initializer/zeros/shape_as_tensor'l2_weights/Adam/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l2_weights*
_output_shapes
:	@
Є
l2_weights/Adam
VariableV2*
	container *
shape:	@*
dtype0*
_output_shapes
:	@*
shared_name *
_class
loc:@l2_weights
Ц
l2_weights/Adam/AssignAssignl2_weights/Adam!l2_weights/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights
z
l2_weights/Adam/readIdentityl2_weights/Adam*
_output_shapes
:	@*
T0*
_class
loc:@l2_weights
Ѓ
3l2_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
valueB"   @   *
_class
loc:@l2_weights*
dtype0*
_output_shapes
:

)l2_weights/Adam_1/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l2_weights*
dtype0*
_output_shapes
: 
ц
#l2_weights/Adam_1/Initializer/zerosFill3l2_weights/Adam_1/Initializer/zeros/shape_as_tensor)l2_weights/Adam_1/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l2_weights*
_output_shapes
:	@
І
l2_weights/Adam_1
VariableV2*
shape:	@*
dtype0*
_output_shapes
:	@*
shared_name *
_class
loc:@l2_weights*
	container 
Ь
l2_weights/Adam_1/AssignAssignl2_weights/Adam_1#l2_weights/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights
~
l2_weights/Adam_1/readIdentityl2_weights/Adam_1*
T0*
_class
loc:@l2_weights*
_output_shapes
:	@

l2_bias/Adam/Initializer/zerosConst*
valueB@*    *
_class
loc:@l2_bias*
dtype0*
_output_shapes
:@

l2_bias/Adam
VariableV2*
dtype0*
_output_shapes
:@*
shared_name *
_class
loc:@l2_bias*
	container *
shape:@
Е
l2_bias/Adam/AssignAssignl2_bias/Adaml2_bias/Adam/Initializer/zeros*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
l
l2_bias/Adam/readIdentityl2_bias/Adam*
T0*
_class
loc:@l2_bias*
_output_shapes
:@

 l2_bias/Adam_1/Initializer/zerosConst*
valueB@*    *
_class
loc:@l2_bias*
dtype0*
_output_shapes
:@

l2_bias/Adam_1
VariableV2*
shared_name *
_class
loc:@l2_bias*
	container *
shape:@*
dtype0*
_output_shapes
:@
Л
l2_bias/Adam_1/AssignAssignl2_bias/Adam_1 l2_bias/Adam_1/Initializer/zeros*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
p
l2_bias/Adam_1/readIdentityl2_bias/Adam_1*
T0*
_class
loc:@l2_bias*
_output_shapes
:@
Ё
1l3_weights/Adam/Initializer/zeros/shape_as_tensorConst*
valueB"@       *
_class
loc:@l3_weights*
dtype0*
_output_shapes
:

'l3_weights/Adam/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l3_weights*
dtype0*
_output_shapes
: 
п
!l3_weights/Adam/Initializer/zerosFill1l3_weights/Adam/Initializer/zeros/shape_as_tensor'l3_weights/Adam/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l3_weights*
_output_shapes

:@ 
Ђ
l3_weights/Adam
VariableV2*
shared_name *
_class
loc:@l3_weights*
	container *
shape
:@ *
dtype0*
_output_shapes

:@ 
Х
l3_weights/Adam/AssignAssignl3_weights/Adam!l3_weights/Adam/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
y
l3_weights/Adam/readIdentityl3_weights/Adam*
T0*
_class
loc:@l3_weights*
_output_shapes

:@ 
Ѓ
3l3_weights/Adam_1/Initializer/zeros/shape_as_tensorConst*
dtype0*
_output_shapes
:*
valueB"@       *
_class
loc:@l3_weights

)l3_weights/Adam_1/Initializer/zeros/ConstConst*
valueB
 *    *
_class
loc:@l3_weights*
dtype0*
_output_shapes
: 
х
#l3_weights/Adam_1/Initializer/zerosFill3l3_weights/Adam_1/Initializer/zeros/shape_as_tensor)l3_weights/Adam_1/Initializer/zeros/Const*
T0*

index_type0*
_class
loc:@l3_weights*
_output_shapes

:@ 
Є
l3_weights/Adam_1
VariableV2*
shared_name *
_class
loc:@l3_weights*
	container *
shape
:@ *
dtype0*
_output_shapes

:@ 
Ы
l3_weights/Adam_1/AssignAssignl3_weights/Adam_1#l3_weights/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
}
l3_weights/Adam_1/readIdentityl3_weights/Adam_1*
T0*
_class
loc:@l3_weights*
_output_shapes

:@ 

l3_bias/Adam/Initializer/zerosConst*
valueB *    *
_class
loc:@l3_bias*
dtype0*
_output_shapes
: 

l3_bias/Adam
VariableV2*
shape: *
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l3_bias*
	container 
Е
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

 l3_bias/Adam_1/Initializer/zerosConst*
dtype0*
_output_shapes
: *
valueB *    *
_class
loc:@l3_bias

l3_bias/Adam_1
VariableV2*
dtype0*
_output_shapes
: *
shared_name *
_class
loc:@l3_bias*
	container *
shape: 
Л
l3_bias/Adam_1/AssignAssignl3_bias/Adam_1 l3_bias/Adam_1/Initializer/zeros*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
p
l3_bias/Adam_1/readIdentityl3_bias/Adam_1*
T0*
_class
loc:@l3_bias*
_output_shapes
: 

"out_weights/Adam/Initializer/zerosConst*
valueB 
*    *
_class
loc:@out_weights*
dtype0*
_output_shapes

: 

Є
out_weights/Adam
VariableV2*
	container *
shape
: 
*
dtype0*
_output_shapes

: 
*
shared_name *
_class
loc:@out_weights
Щ
out_weights/Adam/AssignAssignout_weights/Adam"out_weights/Adam/Initializer/zeros*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
|
out_weights/Adam/readIdentityout_weights/Adam*
T0*
_class
loc:@out_weights*
_output_shapes

: 


$out_weights/Adam_1/Initializer/zerosConst*
valueB 
*    *
_class
loc:@out_weights*
dtype0*
_output_shapes

: 

І
out_weights/Adam_1
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

Я
out_weights/Adam_1/AssignAssignout_weights/Adam_1$out_weights/Adam_1/Initializer/zeros*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(

out_weights/Adam_1/readIdentityout_weights/Adam_1*
_output_shapes

: 
*
T0*
_class
loc:@out_weights

out_bias/Adam/Initializer/zerosConst*
valueB
*    *
_class
loc:@out_bias*
dtype0*
_output_shapes
:


out_bias/Adam
VariableV2*
dtype0*
_output_shapes
:
*
shared_name *
_class
loc:@out_bias*
	container *
shape:

Й
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


!out_bias/Adam_1/Initializer/zerosConst*
dtype0*
_output_shapes
:
*
valueB
*    *
_class
loc:@out_bias

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

П
out_bias/Adam_1/AssignAssignout_bias/Adam_1!out_bias/Adam_1/Initializer/zeros*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:
*
use_locking(
s
out_bias/Adam_1/readIdentityout_bias/Adam_1*
_output_shapes
:
*
T0*
_class
loc:@out_bias
W
Adam/learning_rateConst*
valueB
 *o:*
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
 *wО?*
dtype0*
_output_shapes
: 
Q
Adam/epsilonConst*
valueB
 *wЬ+2*
dtype0*
_output_shapes
: 
о
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
*
use_locking( 
Ч
Adam/update_l1_bias/ApplyAdam	ApplyAdaml1_biasl1_bias/Adaml1_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon-gradients/Add_grad/tuple/control_dependency_1*
use_nesterov( *
_output_shapes	
:*
use_locking( *
T0*
_class
loc:@l1_bias
п
 Adam/update_l2_weights/ApplyAdam	ApplyAdam
l2_weightsl2_weights/Adaml2_weights/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon2gradients/MatMul_1_grad/tuple/control_dependency_1*
use_locking( *
T0*
_class
loc:@l2_weights*
use_nesterov( *
_output_shapes
:	@
Ш
Adam/update_l2_bias/ApplyAdam	ApplyAdaml2_biasl2_bias/Adaml2_bias/Adam_1beta1_power/readbeta2_power/readAdam/learning_rate
Adam/beta1
Adam/beta2Adam/epsilon/gradients/Add_1_grad/tuple/control_dependency_1*
T0*
_class
loc:@l2_bias*
use_nesterov( *
_output_shapes
:@*
use_locking( 
о
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

:@ 
Ш
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
у
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
Э
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
ј
Adam/mulMulbeta1_power/read
Adam/beta1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
T0*
_class
loc:@l1_bias*
_output_shapes
: 

Adam/AssignAssignbeta1_powerAdam/mul*
validate_shape(*
_output_shapes
: *
use_locking( *
T0*
_class
loc:@l1_bias
њ

Adam/mul_1Mulbeta2_power/read
Adam/beta2^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam*
_output_shapes
: *
T0*
_class
loc:@l1_bias

Adam/Assign_1Assignbeta2_power
Adam/mul_1*
use_locking( *
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 
И
AdamNoOp^Adam/Assign^Adam/Assign_1^Adam/update_l1_bias/ApplyAdam!^Adam/update_l1_weights/ApplyAdam^Adam/update_l2_bias/ApplyAdam!^Adam/update_l2_weights/ApplyAdam^Adam/update_l3_bias/ApplyAdam!^Adam/update_l3_weights/ApplyAdam^Adam/update_out_bias/ApplyAdam"^Adam/update_out_weights/ApplyAdam
и
initNoOp^beta1_power/Assign^beta2_power/Assign^l1_bias/Adam/Assign^l1_bias/Adam_1/Assign^l1_bias/Assign^l1_weights/Adam/Assign^l1_weights/Adam_1/Assign^l1_weights/Assign^l2_bias/Adam/Assign^l2_bias/Adam_1/Assign^l2_bias/Assign^l2_weights/Adam/Assign^l2_weights/Adam_1/Assign^l2_weights/Assign^l3_bias/Adam/Assign^l3_bias/Adam_1/Assign^l3_bias/Assign^l3_weights/Adam/Assign^l3_weights/Adam_1/Assign^l3_weights/Assign^out_bias/Adam/Assign^out_bias/Adam_1/Assign^out_bias/Assign^out_weights/Adam/Assign^out_weights/Adam_1/Assign^out_weights/Assign
R
ArgMax/dimensionConst*
dtype0*
_output_shapes
: *
value	B :
v
ArgMaxArgMaxAdd_3ArgMax/dimension*

Tidx0*
T0*
output_type0	*#
_output_shapes
:џџџџџџџџџ
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
Truncate( *

DstT0*
_output_shapes
:
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
range/deltaConst*
dtype0*
_output_shapes
: *
value	B :
_
rangeRangerange/startRankrange/delta*#
_output_shapes
:џџџџџџџџџ*

Tidx0
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
о
save/SaveV2/tensor_namesConst*
valueBBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1*
dtype0*
_output_shapes
:

save/SaveV2/shape_and_slicesConst*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B *
dtype0*
_output_shapes
:
џ
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
№
save/RestoreV2/tensor_namesConst"/device:CPU:0*
dtype0*
_output_shapes
:*
valueBBbeta1_powerBbeta2_powerBl1_biasBl1_bias/AdamBl1_bias/Adam_1B
l1_weightsBl1_weights/AdamBl1_weights/Adam_1Bl2_biasBl2_bias/AdamBl2_bias/Adam_1B
l2_weightsBl2_weights/AdamBl2_weights/Adam_1Bl3_biasBl3_bias/AdamBl3_bias/Adam_1B
l3_weightsBl3_weights/AdamBl3_weights/Adam_1Bout_biasBout_bias/AdamBout_bias/Adam_1Bout_weightsBout_weights/AdamBout_weights/Adam_1
Љ
save/RestoreV2/shape_and_slicesConst"/device:CPU:0*G
value>B<B B B B B B B B B B B B B B B B B B B B B B B B B B *
dtype0*
_output_shapes
:

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices"/device:CPU:0*(
dtypes
2*|
_output_shapesj
h::::::::::::::::::::::::::

save/AssignAssignbeta1_powersave/RestoreV2*
use_locking(*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes
: 

save/Assign_1Assignbeta2_powersave/RestoreV2:1*
validate_shape(*
_output_shapes
: *
use_locking(*
T0*
_class
loc:@l1_bias

save/Assign_2Assignl1_biassave/RestoreV2:2*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
Ђ
save/Assign_3Assignl1_bias/Adamsave/RestoreV2:3*
T0*
_class
loc:@l1_bias*
validate_shape(*
_output_shapes	
:*
use_locking(
Є
save/Assign_4Assignl1_bias/Adam_1save/RestoreV2:4*
validate_shape(*
_output_shapes	
:*
use_locking(*
T0*
_class
loc:@l1_bias
Ј
save/Assign_5Assign
l1_weightssave/RestoreV2:5*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:

­
save/Assign_6Assignl1_weights/Adamsave/RestoreV2:6*
use_locking(*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:

Џ
save/Assign_7Assignl1_weights/Adam_1save/RestoreV2:7*
T0*
_class
loc:@l1_weights*
validate_shape(* 
_output_shapes
:
*
use_locking(

save/Assign_8Assignl2_biassave/RestoreV2:8*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes
:@
Ё
save/Assign_9Assignl2_bias/Adamsave/RestoreV2:9*
use_locking(*
T0*
_class
loc:@l2_bias*
validate_shape(*
_output_shapes
:@
Ѕ
save/Assign_10Assignl2_bias/Adam_1save/RestoreV2:10*
validate_shape(*
_output_shapes
:@*
use_locking(*
T0*
_class
loc:@l2_bias
Љ
save/Assign_11Assign
l2_weightssave/RestoreV2:11*
use_locking(*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@
Ў
save/Assign_12Assignl2_weights/Adamsave/RestoreV2:12*
T0*
_class
loc:@l2_weights*
validate_shape(*
_output_shapes
:	@*
use_locking(
А
save/Assign_13Assignl2_weights/Adam_1save/RestoreV2:13*
validate_shape(*
_output_shapes
:	@*
use_locking(*
T0*
_class
loc:@l2_weights

save/Assign_14Assignl3_biassave/RestoreV2:14*
use_locking(*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: 
Ѓ
save/Assign_15Assignl3_bias/Adamsave/RestoreV2:15*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
Ѕ
save/Assign_16Assignl3_bias/Adam_1save/RestoreV2:16*
T0*
_class
loc:@l3_bias*
validate_shape(*
_output_shapes
: *
use_locking(
Ј
save/Assign_17Assign
l3_weightssave/RestoreV2:17*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
­
save/Assign_18Assignl3_weights/Adamsave/RestoreV2:18*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ *
use_locking(
Џ
save/Assign_19Assignl3_weights/Adam_1save/RestoreV2:19*
use_locking(*
T0*
_class
loc:@l3_weights*
validate_shape(*
_output_shapes

:@ 
 
save/Assign_20Assignout_biassave/RestoreV2:20*
use_locking(*
T0*
_class
loc:@out_bias*
validate_shape(*
_output_shapes
:

Ѕ
save/Assign_21Assignout_bias/Adamsave/RestoreV2:21*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
Ї
save/Assign_22Assignout_bias/Adam_1save/RestoreV2:22*
validate_shape(*
_output_shapes
:
*
use_locking(*
T0*
_class
loc:@out_bias
Њ
save/Assign_23Assignout_weightssave/RestoreV2:23*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 
*
use_locking(
Џ
save/Assign_24Assignout_weights/Adamsave/RestoreV2:24*
validate_shape(*
_output_shapes

: 
*
use_locking(*
T0*
_class
loc:@out_weights
Б
save/Assign_25Assignout_weights/Adam_1save/RestoreV2:25*
use_locking(*
T0*
_class
loc:@out_weights*
validate_shape(*
_output_shapes

: 

Ц
save/restore_allNoOp^save/Assign^save/Assign_1^save/Assign_10^save/Assign_11^save/Assign_12^save/Assign_13^save/Assign_14^save/Assign_15^save/Assign_16^save/Assign_17^save/Assign_18^save/Assign_19^save/Assign_2^save/Assign_20^save/Assign_21^save/Assign_22^save/Assign_23^save/Assign_24^save/Assign_25^save/Assign_3^save/Assign_4^save/Assign_5^save/Assign_6^save/Assign_7^save/Assign_8^save/Assign_9"&"г
trainable_variablesЛИ
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

out_bias:0out_bias/Assignout_bias/read:02random_normal_7:08"
train_op

Adam"
	variablesїє
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
out_bias/Adam_1:0out_bias/Adam_1/Assignout_bias/Adam_1/read:02#out_bias/Adam_1/Initializer/zeros:0VrІ2