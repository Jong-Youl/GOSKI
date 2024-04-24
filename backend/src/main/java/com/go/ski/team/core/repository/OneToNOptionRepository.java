package com.go.ski.team.core.repository;

import com.go.ski.team.core.model.OneToNOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface OneToNOptionRepository extends JpaRepository<OneToNOption, Integer> {
}
