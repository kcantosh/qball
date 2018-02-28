#include <fstream>
#include <vector>

#include <pseudo/base.hpp>
#include <rapidxml.hpp>

namespace pseudopotential {

  class qso : public pseudopotential::base {

  public:
    
    qso(const std::string & filename):
      file_(filename),
      buffer_((istreambuf_iterator<char>(file_)), istreambuf_iterator<char>()){

      buffer_.push_back('\0');
      doc_.parse<0>(&buffer_[0]);

      root_node_ = doc_.first_node("fpmd:species");

      pseudo_node_ = root_node_->first_node("ultrasoft_pseudopotential");
      if(pseudo_node_) type_ = type::ULTRASOFT;

      pseudo_node_ = root_node_->first_node("norm_conserving_semilocal_pseudopotential");
      if(pseudo_node_) type_ = type::NORM_CONSERVING_SEMILOCAL;
      
      pseudo_node_ = root_node_->first_node("norm_conserving_pseudopotential");
      if(pseudo_node_) type_ = type::NORM_CONSERVING;
      
    }

  private:

    ifstream file_;
    vector<char> buffer_;
    rapidxml::xml_document<> doc_;
    rapidxml::xml_node<> * root_node_;
    rapidxml::xml_node<> * pseudo_node_;
    
    
  };

}
