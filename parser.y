%{  
#include <bits/stdc++.h>
#include "nodes.cpp"
using namespace std;

extern int yyparse();
extern map<string, string> mymap;
extern void insertMap(string, string );
int yylex (void);
int yyerror (char const *);

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();

int num=0;

void generatetree(Node* n){
  int ptr=num;
    num++;


    if(n->objects.size()){

        for(auto x : n->objects){

            cout<<n->label<<ptr<<"->";
            generatetree(x);
            // cout<<";\n";
        }

        cout<<n->label<<ptr;
        cout<<"[label=\"";
        n->print();
        cout<<"\"];"<<endl;
        
    }
    else{
      cout<<n->label<<ptr<<";\n";

      cout<<n->label<<ptr;
          cout<<"[label=\"";
          n->print();
          cout<<"\"];"<<endl;
    }
}

/* {} 0 or more
[] 0 or 1*/

%}

%union{
  char* sym;
  Node* node;
}
 
%token<sym> curly_open curly_close class_access STATIC FINAL key_SEAL key_abstract key_STRICTFP field_modifier method_modifier
%token<sym> box_open box_close dot dots less_than greater_than comma ques_mark bitwise_and at colon OR brac_open brac_close bitwise_xor bitwise_or assign semi_colon
%token<sym> class_just_class literal_type AssignmentOperator1 boolean literal keyword throws var
%token<sym> Identifier extends super implements permits
%token<sym> ARITHMETIC_OP_ADDITIVE ARITHMETIC_OP_MULTIPLY LOGICAL_OP Equality_OP INCR_DECR VOID THIS AND EQUALNOTEQUAL SHIFT_OP INSTANCE_OF RELATIONAL_OP1 NEW THROW RETURN CONTINUE FOR IF ELSE WHILE BREAK PRINTLN

%type<node> input
%type<node> ClassDeclaration ClassModifier ClassBody ClassPermits InterfaceTypeList ClassType
%type<node> ClassDecTillPermits ClassDecTillImplements ClassImplements ClassDecTillExtends ClassDecTillTypeParameters ClassExtends
%type<node> TypeArguments TypeArgumentList TypeArgument TypeName TypeParameters TypeParameterList TypeParameter TypeBound
%type<node> WildcardBounds ReferenceType ArrayType Dims PrimitiveType AdditionalBound
%type<node> UnannArrayType UnannPrimitiveType UnannReferenceType UnannType
%type<node> Block BlockStatements BlockStatement LocalVariableDeclaration LocalVariableDeclarationStatement LocalVariableType VariableModifier LocalClassOrInterfaceDeclaration InstanceInitializer
%type<node> VariableDeclarator VariableDeclaratorList VariableInitializer
 
%type<sym> class_modifiers CommonModifiers

%left OR
%left AND
%left bitwise_or bitwise_xor
%left bitwise_and
%left EQUALNOTEQUAL
%left RELATIONAL_OP1 greater_than less_than
%left SHIFT_OP
%left ARITHMETIC_OP_ADDITIVE 
%left ARITHMETIC_OP_MULTIPLY
%right LOGICAL_OP
%right AssignmentOperator1 assign
%left INCR_DECR
%left dot
%left super

%error-verbose

%%
input:
| ClassDeclaration input {cout<<"\n\n"; generatetree($$);}
;

ClassDeclaration:
  ClassModifier class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); $$->add($1->objects); string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($4->objects); cout<<"class declared yayy!!1\n";}
| class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($3->objects); cout<<"class declared yayy!!2\n";}
;

ClassDecTillTypeParameters:
  TypeParameters ClassDecTillExtends {$$=$1; $$->add($2->objects);}
| ClassDecTillExtends {$$=$1;}
;

ClassDecTillExtends:
 ClassExtends ClassDecTillImplements {$$=$1; $$->add($2->objects);}
| ClassDecTillImplements {$$=$1;}
;

ClassDecTillImplements:
  ClassImplements ClassDecTillPermits {$$=$1; $$->add($2->objects);}
| ClassDecTillPermits {$$=$1;}
;

ClassDecTillPermits:
  permits ClassPermits ClassBody {string t1=$1; $$ = new Node();  vector<Node*>v{new Node(mymap[t1],t1),$2,$3}; $$->add(v);}
| ClassBody {$$ = new Node(); $$->add($1);}
;

ClassBody:
  curly_open ClassBodyDeclaration curly_close {string t1=$1,t2=$3; $$ =new Node("ClassBody"); vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); cout<<"classbody1\n";}
| curly_open curly_close {string t1=$1,t2=$2; $$ =new Node("ClassBody");vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);  cout<<"\n---classbody2\n";}
;

ClassBodyDeclaration:
  ClassMemberDeclaration {cout<<"classbodydeclaration1\n";}
| InstanceInitializer {cout<<"classbodydeclaration2\n";}
| StaticInitializer {cout<<"classbodydeclaration3\n";}
| ConstructorDeclaration {cout<<"classbodydeclaration4\n";}
| ClassMemberDeclaration ClassBodyDeclaration {cout<<"classbodydeclaration5\n";}
| InstanceInitializer ClassBodyDeclaration {cout<<"classbodydeclaration6\n";}
| StaticInitializer ClassBodyDeclaration {cout<<"classbodydeclaration7\n";}
| ConstructorDeclaration ClassBodyDeclaration {cout<<"classbodydeclaration8\n";}
;

ConstructorDeclaration:
  class_access ConstructorDeclarator ConstructorDeclarationEnd {cout<<"constructordeclared1\n";}
| ConstructorDeclarator ConstructorDeclarationEnd {cout<<"constructordeclared2\n";}
;

ConstructorDeclarationEnd:
  Throws curly_open ConstructorBody {cout<<"constructordeclaration1\n";}
| curly_open ConstructorBody {cout<<"constructordeclaration2\n";}
;

ConstructorBody:
  ExplicitConstructorInvocation ConstructorBodyEnd {cout<<"ConstructorBody1\n";}
| ConstructorBodyEnd {cout<<"ConstructorBody2\n";}
;

ConstructorBodyEnd:
  BlockStatements curly_close
| curly_close
;

/* ExplicitConstructorInvocation:
| TypeArguments this brac_open ArgumentList brac_close semi_colon
| TypeArguments super brac_open ArgumentList brac_close semi_colon
| ExpressionName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
; */

 ExplicitConstructorInvocation:
  TypeArguments ExplicitConsInvTillTypeArgs
| ExplicitConsInvTillTypeArgs
| TypeName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
;

ExplicitConsInvTillTypeArgs:
  THIS brac_open ArgumentList brac_close semi_colon
| super brac_open ArgumentList brac_close semi_colon
;

ArgumentList:
  Expression
| ArgumentList comma Expression
;

ConstructorDeclarator:
  ConstructorDeclaratorStart ConstructorDeclaratorEnd
;

ConstructorDeclaratorStart:
  TypeParameters Identifier brac_open 
| Identifier brac_open {cout<<"ConstructorDeclaratorStart\n";}
;

ConstructorDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {cout<<"ConstructorDeclarator1\n";}
| FormalParameterList brac_close {cout<<"ConstructorDeclarator2\n";}
| ReceiverParameter brac_close {cout<<"ConstructorDeclarator1\n";}
| brac_close {cout<<"ConstructorDeclarator2\n";}
;

StaticInitializer:
  STATIC Block {cout<<"StaticInitializer\n";}
;

InstanceInitializer:
 Block {$$ = $1;}
;

Block:
  curly_open BlockStatements curly_close {$$=new Node("Block"); string t1=$1,t2=$3; vector<Node*>v{(new Node(mymap[t1],t1)),$2,(new Node(mymap[t2],t2))}; $$->add(v); cout<<"Block1\n";}
| curly_open curly_close {$$=new Node("Block"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v); cout<<"Block2\n";}
;

BlockStatements:
  BlockStatement {$$=new Node("BlockStatements"); $$->add($1); cout<<"BlockStatements1\n";}
| BlockStatements BlockStatement {$$=$1; $$->add($2); cout<<"BlockStatements2\n";}
;

/* BlockStatement:
  LocalClassOrInterfaceDeclaration {cout<<"";}
| LocalVariableDeclarationStatement {cout<<"";}
| Statement {cout<<"";}
; */

BlockStatement:
  Assignment semi_colon {cout<<"mo2222222222222222222\n";}
| LocalClassOrInterfaceDeclaration {$$ = new Node("LocalClassOrInterfaceDeclaration"); $$->add($1); cout<<"LocalClassOrInterfaceDeclaration";}
| LocalVariableDeclarationStatement semi_colon {$$ =$1; string t1=$2; cout<<t1<<"==\n"; $$->add(new Node(mymap[t1],t1));  cout<<"LocalVariableDeclarationStatement\n";}
| Statement
;

LocalVariableDeclarationStatement:
  VariableModifier LocalVariableType VariableDeclaratorList {$$ = new Node("LocalVariableDeclarationStatement"); vector<Node*>v{$1,$2,$3}; $$->add(v); cout<<"LocalVariableDeclarationStatement1\n";}
| LocalVariableType VariableDeclaratorList {$$ = new Node("LocalVariableDeclarationStatement"); vector<Node*>v{$1,$2}; $$->add(v); cout<<"LocalVariableDeclarationStatement2\n";}
;

LocalVariableType:
  UnannType {$$=$1; cout<<"LocalVariableType1\n";}
| var {string t1= $1; $$=new Node(mymap[t1],t1);}
;

/* LocalClassOrInterfaceDeclaration:
  ClassDeclaration
| NormalInterfaceDeclaration
; */
LocalClassOrInterfaceDeclaration:
  ClassDeclaration {$$=$1;}
;

/* ClassMemberDeclaration:
  FieldDeclaration
| MethodDeclaration
| ClassDeclaration
| InterfaceDeclaration
; */

ClassMemberDeclaration:
  FieldDeclaration {cout<<"ClassMemberDeclaration1\n";}
| MethodDeclaration {cout<<"ClassMemberDeclaration2\n";}
| ClassDeclaration {cout<<"ClassMemberDeclaration3\n";}
| semi_colon {cout<<"ClassMemberDeclaration4\n";}
;

MethodDeclaration:
  MethodModifier MethodHeader MethodDeclarationEnd
| MethodHeader MethodDeclarationEnd
;

MethodDeclarationEnd:
  Block {cout<<"MethodDeclaration1\n";}
| semi_colon {cout<<"MethodDeclaration2\n";}
;

MethodModifier:
  method_modifiers
| MethodModifier method_modifiers
| CommonModifiers
| MethodModifier CommonModifiers
;

method_modifiers:
 key_abstract
| key_STRICTFP
| method_modifier
;

MethodHeader:
  TypeParameters MethodHeaderStart {cout<<"MethodHeader1\n";}
| MethodHeaderStart {cout<<"MethodHeader2\n";}
;

MethodHeaderStart:
 Result MethodDeclarator {cout<<"MethodHeader4\n";}
| Result MethodDeclarator Throws {cout<<"MethodHeader4\n";}
;

Throws:
  throws ExceptionTypeList semi_colon
;

ExceptionTypeList:
  ClassType
| ClassType comma ExceptionTypeList
;

MethodDeclarator:
  Identifier brac_open MethodDeclaratorTillRP
;

MethodDeclaratorTillRP:
  UnannType ReceiverParameter MethodDeclaratorTillFP
| MethodDeclaratorTillFP 
;

MethodDeclaratorTillFP:
  FormalParameterList MethodDeclaratorEnd {cout<<"MethodDeclarator2\n";}
| MethodDeclaratorEnd {cout<<"MethodDeclarator3\n";}
;

MethodDeclaratorEnd:
  brac_close
| brac_close Dims
;

FormalParameterList:
  FormalParameter
| FormalParameter comma FormalParameterList 
;

FormalParameter:
  VariableModifier UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableModifier UnannType VariableArityParameter
| UnannType VariableArityParameter
;


// FormalParameter:
//   VariableDeclaratorId {cout<<"FormalParameter1\n";}
// | VariableArityParameter {cout<<"FormalParameter2\n";}
// ;

VariableDeclaratorId:
  Identifier Dims
| Identifier {cout<<"VariableDeclaratorId2\n";}
;

VariableArityParameter:
 dots Identifier
;

VariableModifier:
 FINAL {string t1 = $1; $$= new Node(mymap[t1],t1);}
;

ReceiverParameter:
  THIS comma {cout<<"ReceiverParameter1\n";}
| Identifier dot THIS comma  {cout<<"ReceiverParameter2\n";}
;

Result:
  UnannType {cout<<"result\n";}
| VOID
;

FieldDeclaration:
  FieldModifier UnannType VariableDeclaratorList semi_colon {cout<<"FieldDeclaration1\n";}
| UnannType VariableDeclaratorList semi_colon {cout<<"FieldDeclaration2\n";}
;

FieldModifier:
 field_modifier {cout<<"fieldModifier \n";}
|  FieldModifier field_modifier {cout<<"fieldModifier \n";}
| CommonModifiers
| FieldModifier CommonModifiers
;

CommonModifiers:
  class_access
| STATIC
| FINAL

VariableDeclaratorList:
  VariableDeclarator {$$= new Node("VariableDeclaratorList"); $$->add($1); cout<<"VariableDeclaratorList1\n";}
| VariableDeclaratorList comma VariableDeclarator { $$=$1; string t1=$2; vector<Node*>v{new Node(mymap[t1],t1),$3}; $$->add(v); cout<<"VariableDeclaratorList2\n";}
;

UnannType:
  UnannPrimitiveType {$$ = new Node("UnannType"); $$->add($1); cout<<"UnannType1\n";}
| UnannReferenceType {$$ = new Node("UnannType"); $$->add($1); cout<<"UnannType2\n";}
;

UnannPrimitiveType:
  boolean {string t1= $1; $$=new Node(mymap[t1],t1);}
| literal_type {string t1= $1; $$=new Node(mymap[t1],t1); cout<<"UnannPrimitiveType\n";}
;

UnannReferenceType:
  ClassType {$$=$1;}
| Identifier {string t1= $1; $$=new Node(mymap[t1],t1);}
| UnannArrayType {$$=$1;}
;

UnannArrayType:
  UnannPrimitiveType Dims {$$ = new Node("UnannArrayType"); vector<Node*>v{$1,$2}; $$->add(v);}
| ClassType Dims {$$ = new Node("UnannArrayType"); vector<Node*>v{$1,$2}; $$->add(v);}
| Identifier Dims {$$ = new Node("UnannArrayType"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v);}
;

VariableDeclarator:
  Identifier {$$ = new Node("VariableDeclarator"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1)}; $$->add(v);}
| Identifier Dims {$$ = new Node("VariableDeclarator"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v);}
| Identifier assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3}; $$->add(v); cout<<"VariableDeclarator1\n";}
| Identifier Dims assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4}; $$->add(v); cout<<"VariableDeclarator1\n";}
;

VariableInitializer:
  Expression {$$ = new Node("VariableInitializer"); cout<<"Varinit\n";} // $$->add($1);
| ArrayInitializer {$$ = new Node();} // $$ = $1;
; 

TypeParameters:
  less_than TypeParameterList greater_than {$$=new Node("TypeParameters"); string t1=$1,t2=$3; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add(new Node(mymap[t2],t2)); cout<<"typeparam\n";}
;

ClassExtends:
  extends ClassType {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2);cout<<"extends\n";}
;

ClassImplements:
 implements InterfaceTypeList {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2); cout<<"implements\n";}
;

ClassPermits:
  ClassPermits comma TypeName {$$=$1; string t2=$3->lexeme; $$->lexeme=$$->lexeme+","+t2;}
|  TypeName {$$=$1;}
;

TypeParameterList:
  TypeParameterList comma TypeParameter {$$=$1; string t2=$2; $$->add(new Node(mymap[t2],t2)); $$->add($3); }
| TypeParameter {$$= new Node("TypeParameterList"); $$->add($1);}
;


InterfaceTypeList:
 ClassType {$$=new Node("InterfaceTypeList"); $$->add($1->objects); cout<<"interfacetypelist1\n";}
| InterfaceTypeList comma ClassType { $$=$1; $$->add(new Node("seperator",$2)); $$->add($3->objects);  cout<<"interfacetypelist2\n";}
;

TypeParameter:
 Identifier TypeBound {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects);}
| Identifier {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1));}
;

TypeBound:
  extends ClassType {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); cout<<"typebound1\n";}
| extends ClassType AdditionalBound {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects); cout<<"typebound2\n";}
;

AdditionalBound:
  AdditionalBound bitwise_and ClassType {string t1=$2; $$=$1; $$->add(new Node(mymap[t1],t1)); $$->add($3);}
| bitwise_and ClassType {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2);}
;

ClassType:
TypeName {$$=$1;}
| TypeName TypeArguments {$$=new Node();}
| TypeName dot Identifier {$$=new Node();}
| TypeName dot Identifier TypeArguments {$$=new Node();}
| ClassType dot Identifier {$$=new Node();}
| ClassType dot Identifier TypeArguments {$$=new Node();}
;

TypeArguments:
  less_than TypeArgumentList greater_than {$$=new Node("TypeArgument"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v);  cout<<"typeargs\n";}
;

TypeArgumentList:
 TypeArgumentList comma TypeArgument {$$=$1; string t1=$2; vector<Node*>v{new Node(mymap[t1],t1),$3}; $$->add(v); }
| TypeArgument {$$= new Node("TypeArgumentList"); $$->add($1);}
;

TypeArgument:
  ReferenceType {$$ = $1;}
| ques_mark {string t1=$1; $$ = new Node(mymap[t1],t1);}
| ques_mark WildcardBounds {string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$ = new Node("TypeArgument"); $$->add(v); }
;

WildcardBounds:
  extends ReferenceType {$$ = new Node("WildcardBounds"); string t1=$1; $$->add(new Node(mymap[t1],$1)); $$->add($2->objects); }
| super ReferenceType {$$ = new Node("WildcardBounds"); string t1=$1; $$->add(new Node(mymap[t1],$1)); $$->add($2->objects); }
;

ReferenceType:
  ClassType {$$=$1;}
| ArrayType {$$=$1;}
;

ArrayType:
  PrimitiveType Dims {$$=new Node("ArrayType"); $$->add($1); $$->add($2->objects);   cout<<"primdims\n";}
| ClassType Dims {$$=new Node("ArrayType"); $$->add($1->objects); $$->add($2->objects);   cout<<"primdims\n";}
;

Dims:
 box_open box_close {$$=new Node("Dims"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
| Dims box_open box_close {$$=$1; string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
;

PrimitiveType:
  literal_type {string t1=$1; $$= new Node(mymap[t1],t1);}
;

ClassModifier:
  CommonModifiers {string t1=$1; $$ = new Node(); $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
| ClassModifier CommonModifiers {$$=new Node("ClassModifier"); $$->add($1->objects); string t1=$2; $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
| class_modifiers {string t1=$1; $$ = new Node(); $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
|  ClassModifier class_modifiers {$$=new Node("ClassModifier"); $$->add($1->objects); string t1=$2; $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
;

class_modifiers:
  key_abstract
| key_STRICTFP
| key_SEAL
;

Expression : 
  AssignmentExpression {cout<<num++<<" Khatam----------------------------------------\n";}

;

AssignmentExpression : 
Assignment             {cout<<"Assignment\n";}
| ConditionalExpression {cout<<"Exp\n";}
;

Assignment:
  LeftHandSide AssignmentOperator Expression 
;

LeftHandSide:
FieldAccess      {cout<<"Fieldacc\n";}
| TypeName {cout<<"Expname\n";}
| ArrayAccess    {cout<<"Arraceess\n";}
;

FieldAccess:
Primary dot Identifier {cout<<"PrimdotId\n";}
| super dot Identifier
| TypeName dot super dot Identifier
;

Primary:
PrimaryNoNewArray
| ArrayCreationExpression
;

PrimaryNoNewArray:
  literal
| ClassLiteral {cout<<"Classliteral\n";}
| THIS
| TypeName dot THIS
| brac_open Expression brac_close
| FieldAccess
| ArrayAccess
| MethodInvocation
| ClassInstanceCreationExpression {cout<<"ClassInstance\n";}
;

TypeName:
  Identifier {string t1=$1; $$=new Node("Identifier",t1);}
| TypeName dot Identifier {string t2 =$3; $$=$1; $$->lexeme=$$->lexeme+"."+t2;}
;

Idboxopen:
Identifier box_open
;

Typenameboxopen:
Idboxopen 
| TypeName dot Idboxopen
;

ArrayAccess:
Typenameboxopen Expression box_close
| PrimaryNoNewArray box_open Expression box_close
;

squarebox: 
  box_open box_close 
| squarebox box_open box_close
;

ClassLiteral : 
  TypeName squarebox dot class_just_class 
| TypeName dot class_just_class
| literal_type squarebox dot class_just_class 
| literal_type dot class_just_class
| boolean squarebox dot class_just_class
| boolean dot class_just_class
| VOID dot class_just_class
;

ConditionalExpression: 
  ConditionalOrExpression
| ConditionalOrExpression ques_mark Expression colon ConditionalExpression
;

ConditionalOrExpression : 
  UnaryExpression 
| ConditionalOrExpression OR ConditionalOrExpression                      {cout<<"OR\n";}
| ConditionalOrExpression AND ConditionalOrExpression                     {cout<<"AND\n";}
| ConditionalOrExpression bitwise_or ConditionalOrExpression              {cout<<"or\n";}
| ConditionalOrExpression bitwise_xor ConditionalOrExpression             {cout<<"xor\n";}
| ConditionalOrExpression bitwise_and ConditionalOrExpression             {cout<<"and\n";}
| ConditionalOrExpression EQUALNOTEQUAL ConditionalOrExpression           {cout<<"Equality\n";}
| ConditionalOrExpression RELATIONAL_OP ConditionalOrExpression           {cout<<"Relational\n";}
| ConditionalOrExpression SHIFT_OP ConditionalOrExpression                {cout<<"Shift\n";}
| ConditionalOrExpression ARITHMETIC_OP_ADDITIVE ConditionalOrExpression  {cout<<"add\n";}
| ConditionalOrExpression ARITHMETIC_OP_MULTIPLY ConditionalOrExpression  {cout<<"mult\n";}
| InstanceofExpression
;

UnaryExpression:
  PreIncrDecrExpression                 {cout<<"IncrDecr\n";}
| ARITHMETIC_OP_ADDITIVE UnaryExpression 
| UnaryExpressionNotPlusMinus 
;

PreIncrDecrExpression:
INCR_DECR UnaryExpression
;

UnaryExpressionNotPlusMinus:
  LOGICAL_OP UnaryExpression
| PostfixExpression
| CastExpression {cout<<"C---a----s---t\n";}
;

PostfixExpression:
  Primary {cout<<"PostfixExpression\n";}
| TypeName
| PostIncrDecrExpression
;

PostIncrDecrExpression:
  PostfixExpression INCR_DECR
;

RELATIONAL_OP :
RELATIONAL_OP1 
| greater_than
| less_than
;


CastExpression:
  brac_open literal_type brac_close UnaryExpression
| brac_open ReferenceType brac_close UnaryExpressionNotPlusMinus
| brac_open ReferenceType AdditionalBound brac_close UnaryExpressionNotPlusMinus
;

AssignmentOperator:
assign
| AssignmentOperator1
;

InstanceofExpression:
  ConditionalOrExpression INSTANCE_OF ReferenceType {cout<<"Instance//////////////////\n";}
| ConditionalOrExpression INSTANCE_OF LocalVariableDeclarationStatement  {cout<<"Instance||||||||||||||||||\n";}
; 

MethodInvocation:
  Identifier brac_open ArgumentList brac_close
| Identifier brac_open brac_close
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close
| MethodIncovationStart Identifier  brac_open brac_close {cout<<"methodinvocation\n";}
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close
;

MethodIncovationStart:
  TypeName dot
| Primary dot
| super dot          {cout<<"MethodInvocationStart\n";}
| TypeName dot super dot
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression
| TypeName dot UnqualifiedClassInstanceCreationExpression
| Primary dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression:
  NEW TypeArguments ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen
| NEW ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen {cout<<"UnqualifiedClassInstanceCreationExpression2\n";}
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody
| brac_close ClassBody {cout<<"UnqualifiedClassInstanceCreationExpressionAfter_bracopen\n";}
| brac_close
| ArgumentList brac_close
;

ClassOrInterfaceTypeToInstantiate:
 Identifier {cout<<"ClassOrInterfaceTypeToInstantiate\n";}
| Identifier TypeArgumentsOrDiamond
| Identifier ClassOrInterfaceType2
| Identifier ClassOrInterfaceType2 TypeArgumentsOrDiamond
;

TypeArgumentsOrDiamond:
  TypeArguments
| less_than greater_than
;

ClassOrInterfaceType2:
  dot Identifier
| ClassOrInterfaceType2 dot Identifier
;

Statement:
StatementWithoutTrailingSubstatement
| LabeledStatement
| IfThenStatement
| IfThenElseStatement
| WhileStatement
| ForStatement
| PRINTLN brac_open TypeName brac_close
| PRINTLN brac_open literal brac_close
;

StatementWithoutTrailingSubstatement:
Block
| semi_colon
| ExpressionStatement
| BreakStatement
| ContinueStatement
| ReturnStatement
| ThrowStatement
;

BreakStatement:
BREAK
| BREAK Identifier
;

ContinueStatement:
CONTINUE
| CONTINUE Identifier
;

ReturnStatement:
RETURN
| RETURN Expression
;

ThrowStatement:
THROW Expression 
;

StatementExpression:
Assignment
| PreIncrDecrExpression
| PostIncrDecrExpression
| MethodInvocation
| ClassInstanceCreationExpression
;

ExpressionStatement:
StatementExpression semi_colon
;

LabeledStatement:
Identifier colon Statement
;
IfThenStatement:
IF brac_open Expression brac_close Statement
;

IfThenElseStatement:
IF brac_open Expression brac_close StatementNoShortIf ELSE Statement
;

IfThenElseStatementNoShortIf:
IF brac_open Expression brac_close StatementNoShortIf ELSE StatementNoShortIf
;

StatementNoShortIf:
StatementWithoutTrailingSubstatement
| LabeledStatementNoShortIf
| IfThenElseStatementNoShortIf
| WhileStatementNoShortIf
| ForStatementNoShortIf
;

LabeledStatementNoShortIf:
Identifier colon StatementNoShortIf
;

WhileStatementNoShortIf:
WHILE curly_open Expression curly_close StatementNoShortIf
;

ForStatement:
BasicForStatement
| EnhancedForStatement
;

ForStatementNoShortIf:
BasicForStatementNoShortIf
| EnhancedForStatementNoShortIf
;

BasicForStatement:
BasicForStatementStart Statement
;

BasicForStatementNoShortIf:
BasicForStatementStart StatementNoShortIf

BasicForStatementStart:
FOR brac_open semi_colon semi_colon brac_close 
| FOR brac_open ForInit semi_colon semi_colon brac_close 
| FOR brac_open semi_colon Expression semi_colon brac_close 
| FOR brac_open semi_colon semi_colon ForUpdate brac_close
| FOR brac_open semi_colon Expression semi_colon ForUpdate brac_close
| FOR brac_open ForInit semi_colon semi_colon ForUpdate brac_close
| FOR brac_open ForInit semi_colon Expression semi_colon brac_close
| FOR brac_open ForInit semi_colon Expression semi_colon ForUpdate brac_close
;


ForInit:
StatementExpressionList
| LocalVariableDeclaration
;

ForUpdate:
StatementExpressionList
;

StatementExpressionList:
StatementExpression
| StatementExpressionList comma StatementExpression
;

EnhancedForStatement:
FOR brac_open LocalVariableDeclaration colon Expression brac_close Statement
;

EnhancedForStatementNoShortIf:
FOR brac_open LocalVariableDeclaration colon Expression brac_close StatementNoShortIf
;

WhileStatement:
WHILE brac_open Expression brac_close Statement
;

LocalVariableDeclaration:
LocalVariableType VariableDeclaratorList
| VariableModifier LocalVariableType VariableDeclaratorList
;

ArrayCreationExpression: 
newclasstype ArrayCreationExpressionAfterType
| newprimtype ArrayCreationExpressionAfterType
;

ArrayCreationExpressionAfterType:
DimExprs
| DimExprs Dims
| Dims ArrayInitializer
;

newprimtype:
NEW PrimitiveType
;

newclasstype:
NEW ClassType
;

DimExprs:
  DimExpr
| DimExprs DimExpr
;

DimExpr:
box_open Expression box_close

ArrayInitializer: 
curly_open VariableInitializerList curly_close
| curly_open VariableInitializerList comma curly_close
;

VariableInitializerList:
VariableInitializer 
| VariableInitializerList comma VariableInitializer
;

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int main(int argc, char *argv[])
{
    if (argc == 2)
	{
		set_input_file(argv[1]);
	}
	
	yyparse();

    /* printf("%d %d %d %d\n",titles,paras,words,sentences)); */
    /* fout<<titles<<" "<<paras<<" "<<words<<" "<<sentences<<endl; */

    return 0;
}

int yyerror (char const *s)
{
  return yyerror(string(s));
}