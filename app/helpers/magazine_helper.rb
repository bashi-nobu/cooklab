module MagazineHelper
  def set_crud_path(crud_patarn)
    if crud_patarn == 'create'
      magazine_index_path
    else
      magazine_path(@magazine_address.id)
    end
  end

  def set_crud_method(crud_patarn)
    if crud_patarn == 'create'
      'POST'
    else
      'PATCH'
    end
  end
end
