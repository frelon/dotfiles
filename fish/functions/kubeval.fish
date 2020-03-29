# Defined in - @ line 1
function kubeval --wraps=docker\ run\ -it\ -v\ \(pwd\)/:/res\ garethr/kubeval\ \'/res/\*\' --description alias\ kubeval\ docker\ run\ -it\ -v\ \(pwd\)/:/res\ garethr/kubeval\ \'/res/\*\'
  docker run -it -v (pwd)/:/res garethr/kubeval /res/$argv;
end
